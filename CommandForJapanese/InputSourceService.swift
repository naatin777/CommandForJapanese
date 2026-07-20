import Carbon
import Foundation

@MainActor
final class InputSourceService: InputSourceServicing {
    func switchToEnglish() throws {
        guard let inputSource = findInputSource(
            matchingAnyID: [
                "com.apple.keylayout.ABC",
                "com.apple.keylayout.US"
            ]
        ) else {
            throw InputSourceServiceError.inputSourceNotFound(
                language: "English"
            )
        }

        try select(
            inputSource,
            language: "English"
        )
    }

    func switchToJapanese() throws {
        guard let inputSource = findInputSource(
            matchingAnyID: [
                "com.apple.inputmethod.Kotoeri.RomajiTyping.Japanese",
                "com.apple.inputmethod.Kotoeri.Japanese"
            ]
        ) else {
            throw InputSourceServiceError.inputSourceNotFound(
                language: "Japanese"
            )
        }

        try select(
            inputSource,
            language: "Japanese"
        )
    }

    private func findInputSource(
        matchingAnyID identifiers: [String]
    ) -> TISInputSource? {
        let properties: [CFString: Any] = [
            kTISPropertyInputSourceIsEnabled: true,
            kTISPropertyInputSourceIsSelectCapable: true
        ]

        guard let sources = TISCreateInputSourceList(
            properties as CFDictionary,
            false
        )?.takeRetainedValue() as? [TISInputSource] else {
            return nil
        }

        for identifier in identifiers {
            if let source = sources.first(where: {
                inputSourceID(of: $0) == identifier
            }) {
                return source
            }
        }

        return nil
    }

    private func inputSourceID(
        of inputSource: TISInputSource
    ) -> String? {
        guard let pointer = TISGetInputSourceProperty(inputSource, kTISPropertyInputSourceID) else { return nil }

        return Unmanaged<CFString>.fromOpaque(pointer).takeUnretainedValue() as String
    }

    private func select(
        _ inputSource: TISInputSource,
        language: String
    ) throws {
        let status = TISSelectInputSource(inputSource)

        guard status == noErr else {
            throw InputSourceServiceError.selectionFailed(language: language, status: status)
        }
    }
}
