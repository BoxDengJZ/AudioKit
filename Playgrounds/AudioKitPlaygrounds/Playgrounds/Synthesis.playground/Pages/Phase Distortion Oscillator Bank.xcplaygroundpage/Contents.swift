//: ## Phase Distortion Oscillator Bank
import AudioKitPlaygrounds
import AudioKit

let bank = AKPhaseDistortionOscillatorBank(waveform: AKTable(.square))

AudioKit.output = bank
AudioKit.start()

class PlaygroundView: AKPlaygroundView, AKKeyboardDelegate {

    var keyboard: AKKeyboardView!

    override func setup() {
        addTitle("Phase Distortion Oscillator Bank")

        addSubview(AKPropertySlider(property: "Phase Distortion",
                                    value: bank.phaseDistortion) { sliderValue in
            bank.phaseDistortion = sliderValue
        })

        let adsrView = AKADSRView { att, dec, sus, rel in
            bank.attackDuration = att
            bank.decayDuration = dec
            bank.sustainLevel = sus
            bank.releaseDuration = rel
        }
        adsrView.attackDuration = bank.attackDuration
        adsrView.decayDuration = bank.decayDuration
        adsrView.releaseDuration = bank.releaseDuration
        adsrView.sustainLevel = bank.sustainLevel
        addSubview(adsrView)

        addSubview(AKPropertySlider(property: "Pitch Bend",
                                    value: bank.pitchBend,
                                    range: -12 ... 12,
                                    format: "%0.2f semitones"
        ) { sliderValue in
            bank.pitchBend = sliderValue
        })

        addSubview(AKPropertySlider(property: "Vibrato Depth",
                                    value: bank.vibratoDepth,
                                    range: 0 ... 2,
                                    format: "%0.2f semitones"
        ) { sliderValue in
            bank.vibratoDepth = sliderValue
        })

        addSubview(AKPropertySlider(property: "Vibrato Rate",
                                    value: bank.vibratoRate,
                                    range: 0 ... 10,
                                    format: "%0.2f Hz"
        ) { sliderValue in
            bank.vibratoRate = sliderValue
        })
        keyboard = AKKeyboardView(width: 440, height: 100)
        keyboard.polyphonicMode = false
        keyboard.delegate = self
        addSubview(keyboard)

        addSubview(AKButton(title: "Go Polyphonic") { button in
            self.keyboard.polyphonicMode = !self.keyboard.polyphonicMode
            if self.keyboard.polyphonicMode {
                button.title = "Go Monophonic"
            } else {
                button.title = "Go Polyphonic"
            }
        })
    }

    func noteOn(note: MIDINoteNumber) {
        bank.play(noteNumber: note, velocity: 80)
    }

    func noteOff(note: MIDINoteNumber) {
        bank.stop(noteNumber: note)
    }
}

import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true
PlaygroundPage.current.liveView = PlaygroundView()
