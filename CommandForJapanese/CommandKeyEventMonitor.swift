import CoreGraphics
import Foundation

@MainActor
final class CommandKeyEventMonitor {
    private enum KeyCode {
        static let leftCommand: Int64 = 55
        static let rightCommand: Int64 = 54
    }

    private let onEvent: (CommandKeyEvent) -> Void

    private var eventTap: CFMachPort?
    private var runLoopSource: CFRunLoopSource?

    private var leftCommandIsPressed = false
    private var rightCommandIsPressed = false

    init(onEvent: @escaping (CommandKeyEvent) -> Void) {
        self.onEvent = onEvent
    }

    func start() throws {
        guard eventTap == nil else {
            return
        }

        let eventMask =
            eventMask(for: .flagsChanged) |
            eventMask(for: .keyDown)

        guard let eventTap = CGEvent.tapCreate(
            tap: .cgSessionEventTap,
            place: .headInsertEventTap,
            options: .listenOnly,
            eventsOfInterest: eventMask,
            callback: Self.eventTapCallback,
            userInfo: Unmanaged.passUnretained(self).toOpaque()
        ) else {
            throw CommandKeyEventMonitorError.eventTapCreationFailed
        }

        let runLoopSource = CFMachPortCreateRunLoopSource(
            kCFAllocatorDefault,
            eventTap,
            0
        )

        CFRunLoopAddSource(
            CFRunLoopGetMain(),
            runLoopSource,
            .commonModes
        )

        CGEvent.tapEnable(
            tap: eventTap,
            enable: true
        )

        self.eventTap = eventTap
        self.runLoopSource = runLoopSource
    }

    func stop() {
        if let runLoopSource {
            CFRunLoopRemoveSource(
                CFRunLoopGetMain(),
                runLoopSource,
                .commonModes
            )
        }

        if let eventTap {
            CGEvent.tapEnable(
                tap: eventTap,
                enable: false
            )

            CFMachPortInvalidate(eventTap)
        }

        eventTap = nil
        runLoopSource = nil

        resetCommandState()
    }
    
    private func isSynthetic(
        _ event: CGEvent
    ) -> Bool {
        event.getIntegerValueField(
            .eventSourceUserData
        ) == SyntheticEvent.marker
    }

    private func process(
        type: CGEventType,
        event: CGEvent
    ) {
        guard !isSynthetic(event) else {
            return
        }

        switch type {
        case .flagsChanged:
            processFlagsChanged(event)

        case .keyDown:
            guard leftCommandIsPressed || rightCommandIsPressed else {
                return
            }

            onEvent(.otherKeyDown)

        case .tapDisabledByTimeout,
             .tapDisabledByUserInput:
            reenableEventTap()

        default:
            break
        }
    }

    private func processFlagsChanged(_ event: CGEvent) {
        let keyCode = event.getIntegerValueField(
            .keyboardEventKeycode
        )

        switch keyCode {
        case KeyCode.leftCommand:
            leftCommandIsPressed.toggle()

            let event: CommandKeyEvent = leftCommandIsPressed
                ? .keyDown(.left)
                : .keyUp(.left)

            onEvent(event)

        case KeyCode.rightCommand:
            rightCommandIsPressed.toggle()

            let event: CommandKeyEvent = rightCommandIsPressed
                ? .keyDown(.right)
                : .keyUp(.right)

            onEvent(event)

        default:
            break
        }
    }

    private func reenableEventTap() {
        guard let eventTap else {
            return
        }
        
        resetCommandState()
        
        CGEvent.tapEnable(
            tap: eventTap,
            enable: true
        )
    }

    private func resetCommandState() {
        leftCommandIsPressed = false
        rightCommandIsPressed = false
    }

    private func eventMask(
        for type: CGEventType
    ) -> CGEventMask {
        CGEventMask(1) << type.rawValue
    }

    private static let eventTapCallback: CGEventTapCallBack = { _, type, event, userInfo in
        guard let userInfo else {
            return Unmanaged.passUnretained(event)
        }

        let monitor = Unmanaged<CommandKeyEventMonitor>
            .fromOpaque(userInfo)
            .takeUnretainedValue()

        MainActor.assumeIsolated {
            monitor.process(
                type: type,
                event: event
            )
        }

        return Unmanaged.passUnretained(event)
    }
}

