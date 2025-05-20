import SwiftUI

struct SymptomAdviceView: View {
    let symptom: String
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(symptom)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 15) {
                    AdviceSection(
                        title: "What's happening",
                        content: getSymptomExplanation(),
                        iconName: "info.circle.fill",
                        iconColor: .blue
                    )
                    
                    AdviceSection(
                        title: "How to manage",
                        content: getSymptomManagement(),
                        iconName: "bandage.fill",
                        iconColor: .green
                    )
                    
                    AdviceSection(
                        title: "When to seek help",
                        content: getSymptomWarnings(),
                        iconName: "exclamationmark.triangle.fill",
                        iconColor: .orange
                    )
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationTitle("Symptom Advice")
    }
    
    private func getSymptomExplanation() -> String {
        switch symptom {
        case "Jaw clenching":
            return "Jaw clenching (bruxism) is caused by MDMA stimulating the central nervous system. It's one of the most common side effects and occurs due to increased serotonin activating the jaw muscles."
        case "Eye wiggles":
            return "Eye wiggles (nystagmus) occur due to MDMA's effect on brain regions controlling eye movements. This is normal during the experience and happens because of serotonin's effect on your oculomotor system."
        case "Increased energy":
            return "MDMA releases serotonin, dopamine, and norepinephrine, creating feelings of energy and stimulation similar to amphetamines. This heightened energy comes from your brain's increased neurotransmitter activity."
        case "Euphoria":
            return "This feeling of intense happiness is caused by the flood of serotonin and dopamine MDMA releases in your brain. These neurotransmitters are directly responsible for feelings of pleasure and well-being."
        case "Enhanced touch":
            return "MDMA enhances tactile sensitivity by increasing sensory processing in your brain's somatosensory cortex. Serotonin release increases the pleasure associated with touch sensations."
        case "Sweating":
            return "MDMA affects your body's temperature regulation and can cause hyperthermia (increased body temperature), resulting in sweating as your body tries to cool down. This is a natural response but requires careful management."
        case "Thirst":
            return "MDMA can cause dehydration through increased sweating and physical activity, triggering thirst signals. However, the drug can also impair your body's natural thirst regulation, making balanced hydration important."
        case "Increased heartrate":
            return "As a stimulant, MDMA activates your sympathetic nervous system, increasing heart rate and blood pressure. This is due to norepinephrine release and is a normal physiological response to the drug."
        case "Anxiety":
            return "Anxiety can occur during come-up or come-down phases due to rapid neurotransmitter changes or as a response to intense sensations. This can be related to serotonin and dopamine fluctuations in the brain."
        case "Enhanced music":
            return "MDMA enhances music appreciation by affecting brain regions responsible for auditory processing and emotional responses. Research shows it can increase emotional reactivity to music and make sounds feel more pleasurable."
        case "Talkativeness":
            return "Increased desire to talk comes from MDMA's effects on brain regions involved in social bonding and communication. Serotonin and oxytocin release enhances social connection and reduces social anxiety."
        case "Empathy":
            return "The heightened sense of emotional connection to others is a hallmark effect of MDMA, driven by oxytocin release (the 'bonding hormone') and serotonin activity in brain regions responsible for emotional processing."
        case "Body warmth":
            return "The sensation of warmth throughout your body is related to MDMA's effects on temperature regulation and increased blood flow to your skin. This is connected to the drug's impact on your body's thermoregulation system."
        case "Heightened senses":
            return "MDMA enhances sensory perception by increasing activity in brain regions responsible for processing sensory information. Colors may appear brighter, sounds clearer, and textures more noticeable."
        case "Love feelings":
            return "The profound feelings of love and connection come from MDMA's release of oxytocin and serotonin. These neurotransmitters play key roles in bonding, trust, and emotional attachment."
        case "Light sensitivity":
            return "Increased sensitivity to light occurs because MDMA dilates your pupils (mydriasis) and increases visual cortex activity. This allows more light to enter your eyes and enhances visual processing."
        case "Blurry vision":
            return "Blurry vision can occur due to pupil dilation, changes in eye muscle coordination, and altered visual processing in the brain. This is usually temporary and resolves as the drug effects wear off."
        case "Dizziness":
            return "Dizziness may result from changes in blood pressure, altered brain activity, or vestibular system effects. This sensation can be more noticeable during position changes or in stimulating environments."
        case "Headache":
            return "Headaches can result from changes in blood vessel dilation, dehydration, jaw clenching, or neurochemical fluctuations. They're more common during the come-down phase as neurotransmitter levels adjust."
        case "Nausea":
            return "Nausea occurs due to serotonin's effects on your digestive system and brain's chemoreceptor trigger zone. Serotonin plays a key role in digestive function, and MDMA significantly alters its levels."
        case "Cold extremities":
            return "Cold hands or feet can occur due to blood vessel constriction in extremities as blood is directed to core organs. This is part of your body's complex response to the stimulant effects."
        default:
            return "This is a common effect experienced during MDMA use. Each person's experience varies in intensity and duration. Effects are caused by changes in brain neurotransmitters like serotonin, dopamine, and norepinephrine."
        }
    }
    
    private func getSymptomManagement() -> String {
        switch symptom {
        case "Jaw clenching":
            return "• Chew gum (not too vigorously)\n• Use a pacifier if in an appropriate setting\n• Take magnesium supplements before use (consult healthcare provider first)\n• Practice jaw relaxation exercises\n• Gentle massage of jaw muscles\n• Apply warm compress to the jaw area\n• Stay conscious of clenching and regularly check in to relax your jaw"
        case "Eye wiggles":
            return "• This is normal and temporary\n• Avoid trying to focus on detailed tasks\n• If bothersome, rest in a dimly lit area\n• Remember it will subside as effects wear off\n• Close your eyes periodically to rest them\n• Avoid bright lights or screens if uncomfortable"
        case "Increased energy":
            return "• Dance mindfully, taking regular breaks\n• Avoid overexertion\n• Monitor your body's signals\n• Stay in cool environments\n• Remember to rest periodically\n• Channel energy into conversation if dancing feels too intense\n• Find quiet spaces to calm down if energy feels overwhelming"
        case "Euphoria":
            return "• Enjoy the experience mindfully\n• Stay with trusted friends\n• Create a playlist of favorite music\n• Remember the feeling is temporary and chemically induced\n• Express yourself through dance, art or conversation\n• Take moments to appreciate your surroundings\n• Practice gratitude for positive experiences"
        case "Enhanced touch":
            return "• Enjoy tactile experiences like soft fabrics\n• Respect others' personal boundaries\n• Try light massage or self-massage\n• Have soft items available (blankets, etc.)\n• Explore different textures mindfully\n• Remember consent is essential if touching others\n• Stay cool with different fabric sensations"
        case "Sweating":
            return "• Stay hydrated (but don't overhydrate)\n• Wear lightweight, breathable clothing\n• Take breaks in cooler areas\n• Use a personal fan\n• Wipe down with a cool cloth\n• Avoid excessive layers of clothing\n• Use quick-dry fabrics if available"
        case "Thirst":
            return "• Drink water regularly, but no more than 1 cup per hour\n• Avoid alcohol (increases dehydration)\n• Sports drinks with electrolytes can help\n• Monitor your intake - overhydration is dangerous too\n• Set timer reminders to drink small amounts\n• Sip don't gulp large amounts at once\n• Use body signs beyond thirst to gauge hydration"
        case "Increased heartrate":
            return "• Find a quiet place to sit or lie down\n• Practice deep, slow breathing\n• Stay cool to reduce strain on the heart\n• Avoid other stimulants like caffeine\n• Remember this is usually temporary\n• Place a hand on your chest and focus on slowing your breathing\n• Try the 4-7-8 breathing technique (inhale for 4, hold for 7, exhale for 8)"
        case "Anxiety":
            return "• Practice deep breathing\n• Find a quiet space away from stimulation\n• Talk to a trusted friend\n• Remind yourself it's temporary and part of the experience\n• Change your sensory input (different music, lighting, etc.)\n• Ground yourself by naming 5 things you can see, 4 you can touch, 3 you can hear, 2 you can smell, 1 you can taste\n• Try progressive muscle relaxation"
        case "Enhanced music":
            return "• Create playlists of favorite songs before taking MDMA\n• Use quality headphones for immersive experience\n• Try different music genres to see what feels best\n• Allow yourself to move naturally to the rhythm\n• Explore music with layered sounds\n• Share music experiences with friends\n• Remember music preferences might change during the experience"
        case "Talkativeness":
            return "• Share with trusted friends in a comfortable environment\n• Be mindful of oversharing personal information\n• Take breaks to hydrate when talking extensively\n• Listen actively to others as well\n• Remember conversations may feel more profound than they are\n• Consider recording voice notes if having meaningful insights\n• Be respectful of others who may not want to talk as much"
        case "Empathy":
            return "• Embrace the connection with trusted friends\n• Be mindful that emotions are heightened\n• Express appreciation for important relationships\n• Remember that everyone's experience is unique\n• Take time for meaningful conversations\n• Respect emotional boundaries of others\n• Consider journaling insights about relationships for later reflection"
        case "Body warmth":
            return "• Dress in layers that can be removed\n• Stay in temperature-controlled environments\n• Use a personal fan if available\n• Take breaks from dancing or physical activity\n• Splash cool water on pulse points (wrists, neck)\n• Avoid overcrowded spaces when possible\n• Monitor your temperature subjectively and take cooling breaks"
        case "Heightened senses":
            return "• Create a comfortable sensory environment\n• Have different sensory experiences available (lights, fabrics, sounds)\n• Avoid overwhelming situations if it becomes too intense\n• Try closing your eyes if visual stimulation is overwhelming\n• Explore different textures, sounds, or visual stimuli\n• Use sensory toys like finger lights, soft fabrics, or essential oils\n• Take breaks in quieter, dimmer environments if needed"
        case "Love feelings":
            return "• Enjoy the emotional openness with trusted people\n• Express appreciation verbally\n• Physical touch like hugs can enhance this feeling (with consent)\n• Remember these feelings are amplified by the substance\n• Journal about insights if they feel significant\n• Consider how to integrate these feelings into everyday life\n• Practice gratitude for important relationships"
        case "Light sensitivity":
            return "• Wear sunglasses, even indoors if needed\n• Avoid looking directly at bright or strobing lights\n• Take breaks in dimly lit areas\n• Close your eyes periodically to rest them\n• Adjust phone/screen brightness to lowest comfortable setting\n• Ask friends to help navigate in bright environments\n• Consider having a eye mask available for rest periods"
        case "Blurry vision":
            return "• Rest your eyes periodically\n• Avoid tasks requiring visual precision\n• Stay hydrated as dehydration can worsen symptoms\n• If wearing contacts, bring glasses as a backup\n• Have a trusted friend help navigate if needed\n• Sit down if blurry vision affects balance\n• Focus on other senses like sound or touch instead"
        case "Dizziness":
            return "• Sit or lie down in a comfortable position\n• Avoid sudden movements or position changes\n• Focus on a fixed point if standing\n• Stay hydrated but don't overhydrate\n• Take deep, slow breaths\n• Have a friend assist with walking if needed\n• Find a quiet space away from crowds and noise"
        case "Headache":
            return "• Rest in a quiet, dimly lit area\n• Stay hydrated with small sips of water\n• Apply cool compress to forehead or neck\n• Practice deep breathing to reduce tension\n• Gentle massage of temples or neck\n• Avoid loud noises and bright lights\n• Consider appropriate pain relief after effects wear off (consult healthcare provider)"
        case "Nausea":
            return "• Sit in a comfortable position\n• Take slow, deep breaths\n• Ginger candies or tea can help settle the stomach\n• Avoid strong food smells\n• Eat a light snack if comfortable (crackers, bread)\n• Focus on a fixed point\n• Apply pressure to the P6 acupressure point (inner wrist)\n• Stay hydrated with small sips of water"
        case "Cold extremities":
            return "• Wear warm socks and gloves\n• Rub hands together to generate warmth\n• Move arms and legs periodically to improve circulation\n• Avoid cold environments when possible\n• Layer clothing for flexibility\n• Warm drinks can help raise body temperature\n• Inform friends so they're aware of your comfort level"
        default:
            return "• Stay with trusted friends\n• Take breaks in quieter spaces when needed\n• Stay hydrated but don't overhydrate (about 500ml water per hour)\n• Practice deep breathing if sensations become overwhelming\n• Remember effects are temporary\n• Change your environment if needed\n• Focus on positive aspects of the experience\n• Use grounding techniques if needed (focus on breath, surroundings)"
        }
    }
    
    private func getSymptomWarnings() -> String {
        switch symptom {
        case "Jaw clenching":
            return "Seek help if you experience extreme pain or inability to open/close your mouth. Persistent jaw pain lasting into the next day may need attention."
        case "Eye wiggles":
            return "Seek help if eye movements become severely uncomfortable or are accompanied by extreme vision changes, persistent headaches, or complete inability to focus."
        case "Increased energy":
            return "Seek help if you experience chest pain, extreme shortness of breath, inability to cool down, confusion, or if energy levels feel dangerously high with racing thoughts."
        case "Euphoria":
            return "While euphoria itself isn't dangerous, seek help if it's accompanied by extreme disorientation, difficulty breathing, severe panic, or thoughts of harming yourself or others."
        case "Enhanced touch":
            return "Seek help if enhanced sensation becomes painful or uncomfortable, or if you develop a rash or hives that may indicate an allergic reaction."
        case "Sweating":
            return "Seek help if sweating is extreme and accompanied by high temperature, confusion, disorientation, or if you stop sweating but still feel very hot (this could indicate dangerous overheating)."
        case "Thirst":
            return "Seek help if experiencing extreme thirst that doesn't improve with drinking, confusion, severely reduced urination, rapid heart rate, or extreme fatigue."
        case "Increased heartrate":
            return "Seek help if your heart rate feels extremely rapid or irregular, or if accompanied by chest pain, shortness of breath, extreme lightheadedness, fainting, or severe anxiety."
        case "Anxiety":
            return "Seek help if anxiety becomes overwhelming panic, includes difficulty breathing, chest pain, feelings of doom that don't subside, or thoughts of harming yourself or others."
        case "Enhanced music":
            return "While enhanced music perception isn't physically dangerous, seek help if it becomes overwhelming, causes extreme distress, or if you experience painful sensitivity to sounds."
        case "Talkativeness":
            return "Seek help if you experience extreme dry mouth that doesn't improve with hydration, difficulty speaking, slurred speech not caused by the substance, or vocal cord pain."
        case "Empathy":
            return "While enhanced empathy isn't dangerous, seek help if emotional states become overwhelming, cause severe distress, or lead to thoughts of harming yourself or others."
        case "Body warmth":
            return "Seek help if warmth becomes extreme heat, if you experience confusion, dizziness, nausea, racing heartbeat, or if your skin feels extremely hot but you've stopped sweating."
        case "Heightened senses":
            return "Seek help if sensory enhancement becomes extremely overwhelming, painful, or causes severe distress that doesn't improve with environment changes."
        case "Love feelings":
            return "While feelings of love aren't physically dangerous, seek help if emotional intensity causes extreme distress or if these feelings lead to unsafe decisions or boundary violations."
        case "Light sensitivity":
            return "Seek help if light sensitivity is accompanied by severe eye pain, vision changes that don't resolve, seeing halos around lights, or extreme headache."
        case "Blurry vision":
            return "Seek help if vision problems are severe, persist long after other effects have subsided, are accompanied by eye pain, or if you see flashing lights or have sudden vision loss."
        case "Dizziness":
            return "Seek help if dizziness is severe, doesn't improve with sitting/lying down, is accompanied by fainting, severe headache, confusion, inability to walk, slurred speech, or vomiting."
        case "Headache":
            return "Seek help if you experience a sudden, extremely severe headache (\"worst headache of your life\"), headache with fever, stiff neck, confusion, seizures, or headache after a fall."
        case "Nausea":
            return "Seek help if nausea leads to severe, uncontrolled vomiting, inability to keep liquids down, signs of dehydration, blood in vomit, or severe abdominal pain."
        case "Cold extremities":
            return "Seek help if extremities become extremely cold, numb, blue or white in color, painful, or if sensation doesn't return after warming efforts."
        default:
            return "Seek medical help immediately if experiencing high fever, chest pain, difficulty breathing, confusion, extreme anxiety, seizures, severe headache, irregular or racing heartbeat, loss of consciousness, or thoughts of harming yourself or others."
        }
    }
}

struct AdviceSection: View {
    let title: String
    let content: String
    let iconName: String
    let iconColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(iconColor)
                    .font(.title3)
                
                Text(title)
                    .font(.headline)
            }
            
            Text(content)
                .font(.body)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
    }
}

struct SymptomAdviceView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SymptomAdviceView(symptom: "Jaw clenching")
        }
    }
}