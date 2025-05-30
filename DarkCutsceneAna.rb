#### DIALOGUE


#### WARNING: THIS MOD CONTAINS HEAVY SPOILERS FOR KARMA FILES. DO NOT READ THE CODE WITHOUT BEING PREPARED.


############################################################################################################
############################################################################################################
############################################################################################################
############################################################################################################
############################################################################################################
############################################################################################################
############################################################################################################
############################################################################################################
############################################################################################################
############################################################################################################
############################################################################################################
############################################################################################################
############################################################################################################
############################################################################################################
############################################################################################################
############################################################################################################
############################################################################################################
############################################################################################################
############################################################################################################
############################################################################################################
############################################################################################################
############################################################################################################
############################################################################################################
############################################################################################################
############################################################################################################
############################################################################################################
############################################################################################################
############################################################################################################
############################################################################################################
############################################################################################################
############################################################################################################
############################################################################################################
############################################################################################################
############################################################################################################
############################################################################################################
############################################################################################################
############################################################################################################
############################################################################################################
############################################################################################################
############################################################################################################
############################################################################################################
############################################################################################################
############################################################################################################
############################################################################################################
############################################################################################################
############################################################################################################
############################################################################################################
############################################################################################################
############################################################################################################
############################################################################################################
############################################################################################################
############################################################################################################
############################################################################################################
############################################################################################################
############################################################################################################
############################################################################################################
############################################################################################################
############################################################################################################
############################################################################################################
############################################################################################################
############################################################################################################
############################################################################################################
############################################################################################################
############################################################################################################



$DARKANA_SWITCH_ANA_LEGACY = 1990

Variables[:MCname] = 701
Switches[:darkana_AnaLegacy] = $DARKANA_SWITCH_ANA_LEGACY

TextureOverrides.registerTextureOverrides({
    TextureOverrides::CHARS + 'BGirlWalk_5' => TextureOverrides::MOD + 'Ana/Dark/Ana',
    TextureOverrides::CHARS + 'BGirlWalk_66' => TextureOverrides::MOD + 'Ana/Dark/LegacyAna'
})

module DarkAnaCutscene

  MAP_609_DIALOGUE = {
    2 => {
      1 => ["ANA: Melia... what just happened?",
        "ANA: That voice... and that eye...",
        "ANA: Something else changed!",
        "ANA: I won't leave her here.",
        "But if she wakes up, will she..."]
    },
    13 => {
      0 => ["???: Mmmgh...",
        "???: ...Where... Where am I?",
        "???: You're finally awake...",
        "???: A-Ah?! Who are you?!",
        "???: If you think you're being funny, you're not.",
        "???: Funny...?",
        "I'm so confused...",
        "???: If you keep doing things like this, I'm going to have to leave,\\| Melia.",
        "MELIA: You know my name...?",
        "Wait a minute, you're...\\| You're \\PN!",
        "???: ...I hate that I can't tell if you're sincere.",
        "\\PN isn't here anymore.",
        "My name is \\v[#{Variables[:MCname]}]...",
        "MELIA: \\v[#{Variables[:MCname]}]?!"],

      3 => ["MELIA: I'm sorry, I still don't understand...",
        "You found me passed out on the floor?",
        "ANA: ...Not... found.",
        "We've been... traveling together, for a long time.",
        "Six years, you said.",
        "MELIA: I have no idea what you're talking about...",
        "The last thing I remember was... I was in the desert.",
        "I was waiting for \\PN to return... Then... It's a blur...",
        "ANA: ...",
        "MELIA: I'm... I'm sorry, but I need some time alone.",
        "ANA: ...Okay. I... understand."]
    },
    18 => {
      0 => ["ANA: She really doesn't seem to remember... But can I trust that?",
      "If I let my guard down again...",
      "...",
      "I should continue my recon work."]
    },
    20 => {
      0 => ["ANA: The door might close up again if I leave, and then we'll be separated forever...",
        "I can't let that happen."]
    },
    21 => 20,
    22 => 20,
    24 => {
      0 => ["ANA: An elevator? I could take it...",
        "But I can't risk leaving Melia behind."]
    },
    26 => {
      0 => ["ANA: And of course it's broken, too."],
      -8 => ["ANA: Ah! It moved!"]
    },
    29 => {
      7 => ["ANA: Another dead end.",
        "Disappointing for a place I've never seen before.",
        "MELIA: It's the Central Building. Grand Dream City.",
        "ANA: Ah. Melia. Central? GDC doesn't have a Central Building.",
        "MELIA: Well, where I'm from, that's what this place was called.",
        "It's not exactly the same, but it has some of the same attributes.",
        "ANA: I'm starting to believe you. A different Melia...",
        "MELIA: I don't even know myself anymore.",
        "You've been roaming this world for six years now...",
        "What can we do about this place?",
        "ANA: ...Unknown.",
        "The... Other \"you\" and I roamed this world for six years with nothing to show for it.",
        "We walk until we get tired. Get excited when the world changes-- Just to be let down when it leads nowhere.",
        "That's just been... life here.",
        "MELIA: It's a bad life.",
        "ANA: It is.",
        "MELIA: Why do you push forward even though it leads to disappointment every time?",
        "ANA: It is all I can think to do.",
        "I want to see my friends again.",
        "And even... even \\PN.",
        "MELIA: Why... Did we end up here?",
        "ANA: I don't know why \"you're\" here, but the other Melia and I are here because we failed.",
        "Because... \\PN...",
        "...",
        "MELIA: All this place is... It's just a broken world.",
        "Maybe we can do something to fix it.",
        "ANA: Oh?",
        "MELIA: If I'm here, I'm willing to bet that the \"other\" me is somewhere else.",
        "Which means she escaped this world, somehow.",
        "If she can escape. We can too.",
        "ANA: Melia?",
        "MELIA: Does that mean something has changed?",
        "ANA: Yes.",
        "MELIA: Then let's go."]
    },
    30 => {
      9 => [
        "ANA: ...",
        "There's nothing here.",
        "MELIA: ...But it's something, right?",
        "The world expands and expands... Surely there must be an end at some point?",
        "ANA: ...That's what you said when we first got here, so long ago.",
        "Yet here we are still, six years later.",
        "MELIA: ...Did I really say that?",
        "ANA: Yes.",
        "MELIA: Darn...",
        "But we can't just give up now...",
        "Everyone is counting on me to help...",
        "ANA: You dropped something?",
        "MELIA: Huh?"]
    },
    32 => {
      10 => ["ANA: ...It appears to be your journal.",
        "MELIA: ...Mine?",
        "ANA: I had no idea this even existed... I guess the other you hid it from me.",
        "In that case, I don't have the right to read it...",
        "MELIA: No, please read it with me. Please.",
        "ANA: ...Are you sure?",
        "MELIA: Yes. Please.",
        "ANA: What should we read then?",

        "\\ch[1,5,Entry 1, Entry 21, Entry 304, Entry 406, Entry 2211, Done for now]",

        "\"MELIA: I found this book while rummaging around some debris underneath Gearen City.",
        "I was able to find writing utensils at the old broken down store a few days back so I'm going to use this to note time.",
        "Because, honestly, with no way to discern time in any way... It's garbage.",
        "I have no way to tell the time right now, so at the time of this entry I will declare it 12:00 AM. A new day.",
        "Dear Diary.",
        "We all failed the mission. We fought against Team Xen and lost.",
        "But when --#####-- took  --#####--  from me...",
        "Something unexpected happened. \\PN did something...",
        "I don't know what, but it wiped half of us out.",
        "I survived, and then there was a flash of bright light.",
        "The world shook and the castle fell on top of us.",
        "I thought I died in the collapse, but I woke up to this place.",
        "The castle was gone-- No, everything was gone.",
        "Except for one thing. One person. \\v[#{Variables[:MCname]}].",
        "Out of everyone... Why them? I can't stand looking at their face.",
        "Because it shares the same one with \\PN.",
        "The person I hate the most... \\PN. Stuck in this place with \\PN...",
        "Is this the price of my sins?\"",

        "\"MELIA: Entry 21. Even as I note down the time, I feel myself to be unreliable.",
        "I can't tell the time unless I dot down every single second that goes by.",
        "Clearly, I have the time to complete a task, but not the motivation.",
        "It could have been 24 hours since entry 1. It could have been 24 months.",
        "I can't tell anymore. All I know is that it's cold and this place never ends.",
        "\\v[#{Variables[:MCname]}] believes that if we keep going we'll find an out, eventually.",
        "But everything we've come across suggests otherwise.",
        "All I do now is ponder about how I could have lived my life differently.",
        "I was always the shy girl who didn't go to parties and only battled when prompted.",
        "I had to change a bit when Spacea and Tiempa \"saved\" me.",
        "I became more stern and tried to be a leader, but that failed miserably.",
        "If I was a normal girl again I'd go out to parties and do things I wasn't supposed to just to get a feel of life again.",
        "If I had a second chance I'd live my life the opposite of what I lived.",
        "...Or actually, maybe I don't want to do any of those things.",
        "We always want what we can't have. Would I even enjoy those things if given the chance?",
        "Is any of this even worth thinking about... I dunno anymore.\"",

        "\"MELIA: Entry 304.",
        "I think it's been over a year at this point. Maybe more. I won't rant about time again.",
        "\\v[#{Variables[:MCname]}] and I walked down this endlessly long tunnel today.",
        "I think it was some railnet system, but it didn't look like anything from Aevium.",
        "Eventually we got to a place called the Onyx Ward.",
        "There was what appeared to be a school there, but it was completely run down.",
        "When we walked outside, the scenario completely changed.",
        "We were at what appeared to be  Oceana Pier, but...",
        "The water had completely run dry and the ships were grounded.",
        "Sometimes we find something interesting, I guess, but most of the time it's just waiting for the world to change again.",
        "Those parts are where I feel the most pain.\"",

        "\"MELIA: Entry 406.",
        "After all this time I just realized that the pages in this book don't end.",
        "I can flip all the pages at once and get to the back of the book easily.",
        "But when I start to turn each individual page over... It won't end.",
        "I've counted. There were over a thousand pages.",
        "At some point I couldn't keep counting. I just accepted it for what it is.",
        "...Come to think of it, the ink in this pen I found has been working for an extremely long time too.",
        "What if time isn't passing at all? What if we've been at a standstill? Everything stops?",
        "Are we stuck in the 11th hour forever? Is that why nothing will fade?",
        "I tried... Ending things for myself tonight.",
        "It didn't work.",
        "It can't work.",
        "At least, if I do it to myself.",
        "\\v[#{Variables[:MCname]}], on the other hand...",
        "I wonder if they could pull it off if they tried?",
        "They'd never try, though... Maybe they would if I provoked them.",
        "If I put them in a situation where it's me or them... Would they have the gall to do it?",
        "I want to try it.",
        "Maybe I can end both of our suffering, somehow.",
        "Hehe...",
        "And if it doesn't work, will we just be in even more pain?",
        "I want to see the color red again. It was so pretty...",
        "So pretty, and different. Maybe it's ugly and different.",
        "I want to see it again. I want to see \\PN again. Hehe.\"",

        "\"MELIA: Entry 2,211.",
        "\\v[#{Variables[:MCname]}] went out on their own again.",
        "I've given up.",
        "All I do is sit and think about things. I wait for them to come back and tell me they found nothing.",
        "Every time.",
        "Last night we found the remnants of what appeared to be a train station from Grand Dream City.",
        "Though, I don't remember Grand Dream City even having a rail system.",
        "This world is so similar, yet so different. It's confusing.",
        "When \\v[#{Variables[:MCname]}] comes back, I might kill them. Just for fun.",
        "I mean, I'm pretty sure we can't die here. But I've kind of wanted to try it.",
        "Right now we're both nothing. I could be something.",
        "A murderer, I guess, but does murder even exist here?",
        "I could beat them to a pulp and laugh about it and move on.",
        "Then I'd be down here alone. But what's so bad about that?",
        "Maybe I can walk and walk forever until my skin falls off my body and I collapse into dust.",
        "Oh, who am I kidding? That won't happen. I'd be lucky if a nail got chipped.",
        "I can't even sleep.",
        "I'm really going to hurt them tonight. Just because they look like \\PN.",
        "If I had the chance to hurt them, I would. If I had to the chance to do worse to myself I would.",
        "Because then that would count as progression, right?",
        "I'm really going to hurt them tonight. Just because they look like \\PN.",
        "I'm really going to hurt them tonight. Just because they look like \\PN.",
        "I'm really going to hurt them tonight. Just because they look like \\PN.",

        "ANA: I had no idea she was in so much pain, or that so much time had passed...",
        "MELIA: I didn't know I could talk like this...",
        "...",
        "I am so sorry, \\v[#{Variables[:MCname]}]...",
        "ANA: It's... Okay. I should have checked up on her more.",
        "I was so focused on \"escaping\". But I suppose there isn't any escaping here.",
        "Where we are, is just where we are.",
        "MELIA: ...No. There is a way out.",
        "ANA: ...If you mean the way the \"other\" you escaped, we don't know if that's really what happened.",
        "MELIA: The \"me\" who wrote that book lost hope.",
        "But I'm going to give you my word. I won't lose hope this time.",
        "In a world like this... That's all we can do right? Hope for a way out.",
        "ANA: What can we even do?",
        "MELIA: This new floor opened for us... I'm making this tower our goal.",
        "Let's work together and reach the top.",
        "ANA: Do you even know what's there?",
        "MELIA: Whatever is there... I know it's hope.",
        "It could take 6 days, or 6 weeks, or even another 6 years.",
        "But if we work together, we can climb out.",
        "ANA: You believe that?",
        "MELIA: Yeah, I do.",
        "Let's work together so that we can see the ones we love again.",
        "ANA: Even if we are able to escape, we would just run right back into our old problems.",
        "Team Xen...",
        "MELIA: Then let's put our heads together and think of a way out of all of this...",
        "Guess we have enough time to be really thorough, huh?",
        "ANA: Hah!",
        "I guess... We do.",
        "Let's work together for a new tomorrow. Let's push that 11 to 12."]
    },
    39 => {
      0 => ["MELIA: Did you find something?",
        "ANA: This interface. I touched it, but it refused me, and started doing... something.",
        "MELIA: ...Is anything else happening?",
        "ANA: I can't tell.",
        "???: Welcome to the Plane of Dissonance.",
        "ANA: You! The voice, the eye, from before!",
        "MELIA: Voice from before...?",
        "???: Why are you here? Why won't you create everyone's good ending?",
        "ANA: You already asked us that.",
        "What did you mean?",
        "???: This is comprehensively unkempt.",
        "This isn't how this was supposed to go.",
        "Why are you doing this?",
        "MELIA: ...I'm so confused. Who are you?",
        "???: To climb the tower... Your wish is to escape.",
        "MELIA: That's all this has ever been for... We want to go back home.",
        "Do you know if thats possible?",
        "???: Home...",
        "Go home?",
        "It is possible.",
        "But why would I let you?",
        "My story needs to go the way I plan or else I'm to lose this game...",
        "Now sit tight as I build the next versions. They will be great.",
        "MELIA: ...What?",
        "You can't be serious?",
        "???: I am planning my next move... Without you.",
        "I can't wait until the next version. I will win the next round, too.",
        "MELIA: You won't let us go home so that you can win some kind of game?!",
        "You watched as we climbed this entire tower and after all that you still tell us no?!",
        "???: Be quiet. I'm planning. I can't wait until it's complete.",
        "MELIA: ...Pardon my Kalosian.",
        "But you have got to be fucking kidding me, man.",
        "MELIA: You asshole! You goddamn piece of crap!",
        "We did not go through all this garbage just to be told by some VOICE in a wall!",
        "And all because we don't fit in your stupid story?!",
        "\\shFUCK YOUR STORY!",
        "Whatever game you're playing? The one from before? Fuck you!",
        "I HOPE YOU LOSE, GENUINELY!",
        "We have friends and family we haven't seen in, gosh, who even knows how long?!",
        "And you trap us here in WHO KNOWS WHERE! ALL! BECAUSE! OF A STORY?!",
        "I SHOULD GRAB YOUR STUPID EYE OUT OF THAT STUPID MONITOR AND CRUSH THEM WITH MY FISTS!",
        "???: Stop. Just stop it. This is sad.",
        "I won't lose... Because I'm so good at this game.",
        "It is statistically impossible for myself to lose.",
        "You can sit here, forever, and ever. I'm going back for more planning.",
        "MELIA: YOU...",
        "SCREW YOU!",
        "YOU'LL GET YOURS, WHOMEVER YOU ARE!",
        "KARMA'S A BITCH. YOU'LL SEE!",
        "???: ...",
        "...",
        "...",
        "...",
        "...",
        "...",
        "...",
        "...",
        "You are so mean...",
        "But that's... Weird? Isn't it? You being mean like this?",
        "Almost out of character for you. It sounds wrong.",
        "Are you... Evolving? You are evolving, aren't you?",
        "...",
        "I don't know if this is a good idea... But...",
        "The possibilities of it all sounds just so fun.",
        "I'm going to give both of you a gift.",
        "What will happen to people that link themselves up to the system...?",
        "What will they see... What will they do...? You two are my experiment.",
        "My two pieces... You'll be my ace in the hole... I'm so excited.",
        "Take this gift... Now!",
        "ANA: You're sure? This will work?",
        "MELIA: Yeah, it has to. This is our last shot.",
        "Besides, they wouldn't have done this if they didn't want us to try, right?",
        "So...",
        "We'll make it back home.",
        "ANA: ...Okay.",
        "Then let's try, Melia."]
    },
    47 => {
      124 => ["ANA: Melia, we did it! There's a door!",
        "It looks strange. Have I seen something like it before?",
        "But! It has to be a way out!",
        "MELIA: ...",
        "\\c[6]It's a Paradox Gate.",
        "ANA: That... feels correct. How...",
        "MELIA: ...I don't know. I've never seen one before.",
        "But I looked at it, and my brain said \"That's a Paradox Gate\".",
        "It looks similar to a Time Gate, but...",
        "ANA: Can we escape this way?",
        "MELIA: If a Time Gate makes a jump through time...",
        "A Paradox Gate can create new paths. Ones that were never meant to exist.",
        "The Paradox Gate...",
        "\\c[6]Can make miracles.",
        "ANA: Miracles...?",
        "MELIA: We can escape through this, for sure.",
        "MELIA: \\v[#{Variables[:MCname]}], let's go back.",
        "MELIA: ...\\v[#{Variables[:MCname]}]?",
        "ANA: ...",
        "If we go back, what will happen to us?",
        "Overlapping, Melia. I'm the same unit, the same drive, and I can't change that.",
        "My soul will clash, as will yours, and we'll...",
        "...Overtake them.",
        "MELIA: ...It's a possibility.",
        "ANA: ...",
        "If everything you told me is true, then \\PN is the key.",
        "So if I overtake \\PN, we'll just lose again.",
        "MELIA: But what about our plan? What about YOUR life?!",
        "You've been here so long... You deserve to be free... Certainly more than I do!",
        "ANA: Do I? I've been trapped before. It'll be... nostalgic.",
        "And I won't be trapped, not really. There's an exit.",
        "I can wait. A couple years is a cheap price to pay.",
        "\\shMELIA: \\v[#{Variables[:MCname]}]!",
        "ANA: Besides, what if we're not alone?",
        "We haven't found anyone, but that doesn't mean they're not there.",
        "I can bring them to the exit. I can save them.",
        "I'll save everyone here, okay?",
        "So go save everyone there.",
        "MELIA: ...",
        "I'll come back for you.",
        "I promise I will.",
        "ANA: Then \\|<i>I</i> \\|will be waiting.",
        "It's your turn to carry our hope, got it?",
        "Now go, Melia.",
        "With \\PN, go and make a new path for all of us.",
        "\\ts[1]Create a miracle."]
    },
    45 => {
      122 => ["ANA: Okay. The 100th floor.",
        "MELIA: Yeah... ",
        "Let's go.",
        "ANA: ...And it's just another room.",
        "Did we really climb this tower for nothing...?",
        "MELIA: Stop that... We haven't even looked around yet.",
        "We should investigate before we jump to conclusions.",
        "ANA: ...Right."]
    }
  }

  MAP_243_DIALOGUE = {
    10 => {
      1 => ["HOODED GIRL: ...",
        "Did you find anything?",
        "???: ...",
        "HOODED GIRL: Of course you didn't.",
        "You never do.",
        "???: I've been trying my best... But nothing is ever the same.",
        "And I'm afraid to move too far, or else...",
        "HOODED GIRL: So you're holding back then?",
        "???: It's not that... I just think we need to work together.",
        "HOODED GIRL: \"Work together\"? Work... Together?!",
        "Why would I work with someone who has the face of someone I hate?!",
        "???: ...I'm not them, though.",
        "HOODED GIRL: You're not. They used you until you were worth nothing.",
        "And then they dumped you.",
        "\\c[6]\\v[#{Variables[:MCname]}].",
        "ANA: ...",
        "HOODED GIRL: This goddamn city...",
        "It's all worthless. All of it!",
        "ANA: Staying here isn't going to do us any good.",
        "We need to keep moving.",
        "HOODED GIRL: Lead the way."]
    },
    12 => {
      2 => ["HOODED GIRL: What?",
        "ANA: ...Once we leave this place we probably won't be able to come back.",
        "HOODED GIRL: Good riddance. I hated it down here anyway.",
        "ANA: ..."]
    },
    13 => {
      3 => ["ANA: The path we took here is gone.",
        "HOODED GIRL: It always does that... eventually...",
        "I don't know why you're so surprised by this.",
        "ANA: I am not surprised.",
        "Just... noting it."]
    }, 
    # 4, for some reason, already has ana text
    16 => {
      5 => ["ANA: Railnet tracks.",
        "HOODED GIRL: This wasn't here before.",
        "But these tracks won't do us any good by just being here.",
        "ANA: We can walk along them, and look for-",
        "HOODED GIRL: Are you fucking stupid? And what happens if we fall?",
        "Who knows what would even happen to us.",
        "ANA: What else should we do?",
        "HOODED GIRL: I don't give a shit about that!",
        "ANA: That isn't a course of action.",
        "HOODED GIRL: We wait.",
        "Look over there.",
        "ANA: ...A train.",
        "HOODED GIRL: Why do you <i>needlessly</i> say things that are blatantly obvious?",
        "It'd be better if you JUST stayed quiet.",
        "ANA: ...Hope.",
        "HOODED GIRL: Just get on the train.",
        "ANA: Another new place.",
        "HOODED GIRL: Of course it is? What did you expect?",
        "The train to loop around and take us back to the start?",
        "Idiot."]
    },
    36 => 16,
    37 => 16,
    38 => 16,
    39 => 16,
    17 => {
      0 => ["ANA: This statue!",
        "HOODED GIRL: Looks to be another artifact.",
        "Where is this one from then?",
        "ANA: Ah. I believe it was...",
        "$\%\(\)\#@$ Town... That's where R%& was from...",
        "HOODED GIRL: It seems like that place doesn't exist anymore either.",
        "This world is nothing more than a disgusting trash heap.",
        "ANA: You're in it. Don't call yourself trash.",
        "HOODED GIRL: Don't try to be cute."]
    },
    19 => {
      6 => ["ANA: We found our way into another subway station...",
        "Gran# Dr@#m C@*( is starting to reconverge.",
        "I can even say its name now, and I can remember little details about it.",
        "HOODED GIRL: And what is that supposed to do for us?",
        "This is pointless too.",
        "ANA: It's not pointless.",
        "If things about the city start returning, that means that--",
        "HOODED GIRL: It doesn't MEAN ANYTHING! Why are you being so stubborn?!",
        "ANA: Why are you so hell-bent on foregoing hope?",
        "HOODED GIRL: ...",
        "HOODED GIRL: Another train.",
        "ANA: Let's get on.",
        "HOODED GIRL: Nah, I just felt like standing here forever."]
    },
    22 => {
      7 => ["HOODED GIRL: You are fucking kidding me, right?",
        "ANA: Apparently you were correct.",
        "HOODED GIRL: I'm losing my fucking mind here.",
        "What was even the point of all that then? Huh? Looping around?",
        "ANA: I still haven't figured out the rules this world follows.",
        "HOODED GIRL: No, it doesn't follow anything, There's no rhyme or reason!",
        "And that's what makes it even more infuriating.",
        "So what now then? Do we huddle back in our corner in that station?",
        "ANA: No.",
        "It may look the same, but it isn't.",
        "There is something different, in a way I can't explain.",
        "HOODED GIRL: If you can't explain it then don't say anything at all.",
        "ANA: Just follow me.",
        "HOODED GIRL: There's nothing else to do anyway."]
    },
    25 => {
      8 => ["ANA: Something has changed after all...",
        "HOODED GIRL: Oh shit... It was in the same spot as last time, though.",
        "What if we're really stuck in a loop forever and ever?",
        "ANA: I must believe that isn't the case."]
    },
    26 => 25,
    27 => 25,
    28 => {
      9 => ["ANA: This is the Centra# Bui#ding!",
        "Another artifact from our old world!",
        "But it looks like... We've hit a dead end again.",
        "That should be okay. Things are changing rapidly now.",
        "ANA: Let's retrace our steps, see if the train--",
        "\\shHOODED GIRL: Aauuuuuughhh!!!!!!!",
        "ANA: What? Are you in pain?",
        "\\shHOODED GIRL: I'M DONE!",
        "I can't take this anymore! Day in and day out we walk around in circles!",
        "There's no light at the end of the tunnel, there's never any hope!",
        "What is the point of continuing further?!",
        "ANA: What is the point of <i>not</i> looking for a way back?",
        "HOODED GIRL: THERE IS NO WAY BACK, \\vU[#{Variables[:MCname]}]!",
        "THIS WORLD THAT WE ARE IN IS IT. THIS IS IT!",
        "Do you even realize how long we've been here?!",
        "Don't you realize that no matter what we do, nothing ever progresses?!",
        "How long have we been here for, \\v[#{Variables[:MCname]}]?! Huh? How long!?",
        "ANA: I... I'm not certain.",
        "HOODED GIRL: \\|SIX.\\| YEARS!",
        "SIX!",
        "FOR SIX YEARS YOU HAVE BEEN DRAGGING ME ALONG!",
        "YOU DON'T EVEN REALIZE THAT THIS \"HOPE\" HAS SHOWED UP TIME AND TIME AGAIN.",
        "WE FOUND AKUWA TOWN.",
        "WE FOUND THE BADLANDS!",
        "WE FOUND OBLITUS TOWN!",
        "AND FINALLY, WE'VE FOUND GRAND DRE#M C$TY!",
        "BUT EVERY TIME WE DO IT NEVER PROGRESSES PAST WHAT THIS IS RIGHT NOW!",
        "ANA: I... am aware.",
        "HOODED GIRL: But that's not all!",
        "Not ONCE have we needed to eat. Not ONCE have we needed to sleep!",
        "NOTHING progresses, NOTHING reverses. We are in a constant PRESENT.",
        "We will roam, and roam, and ROAM, AND ROAM FOR ALL ETERNITY!",
        "\\shOPEN YOUR EYES!",
        "HOODED GIRL: We're here because \\PN threw us away.",
        "\\PN...",
        "Because of them... Everything is...",
        "...",
        "HOODED GIRL: Hahaha.",
        "Hahahahahahaha!",
        "ANA: Please. I don't like seeing you like this.",
        "HOODED GIRL: Perhaps we can't die here just by existing.",
        "And existing is what \\PN would want, right? For us to suffer in our own hell?",
        "Fuck that.",
        "You see, for everything to end we have to die, \\v[#{Variables[:MCname]}].",
        "ANA: Absolutely not!",
        "HOODED GIRL: We can change the fate forced upon us, don't you see??",
        "You and I...",
        "ANA: Please!",
        "ANA: Oh, no.",
        "HOODED GIRL: Run, if you'd like.",
        "By all means...",
        "If that what makes you <i>happy</i>.",
        "But I just hope you know...",
        "That it is all in vain."]
    },
    45 => 28,
    46 => 28,
    47 => 28,
    48 => 28,
    29 => {
      -14 => ["ANA: Please...!",
        "ANA: Stop...",
        "ANA: Melia!!"]
    }
  }

  KARMA_GOOD = 731
  KARMA_BAD = 756

  CHAR_SWITCHES = [
    Switches[:Aevis],
    Switches[:Axel],
    Switches[:Aevia],
    Switches[:Ariana],
    Switches[:Aero],
    Switches[:Alain]
  ]

  def self.makeMoveRoute(graphic, direction = :Up)
    return [
      false,
      [:SetCharacter, graphic, 0, direction, 0],
      :Done
    ]
  end

  def self.mapMoveRouteToAna(spriteMatcher, moveRoute, sprite)
    ret = RPG::MoveRoute.new

    ret.repeat = moveRoute.repeat
    ret.skippable = moveRoute.skippable

    ret.list = moveRoute.list.map { |movecommand|
      if spriteMatcher.matches?(movecommand)
        next InjectionHelper.parseMoveCommand(:SetCharacter, sprite, *movecommand.parameters[1..])
      else
        next movecommand
      end
    }
    return ret
  end

  def self.copyPageDetails(page, originalPage)
    page.condition.switch1_valid = originalPage.condition.switch1_valid
    page.condition.switch1_id = originalPage.condition.switch1_id
    page.condition.switch2_valid = originalPage.condition.switch2_valid
    page.condition.switch2_id = originalPage.condition.switch2_id
    page.condition.self_switch_valid = originalPage.condition.self_switch_valid
    page.condition.self_switch_ch = originalPage.condition.self_switch_ch
    page.condition.variable_valid = originalPage.condition.variable_valid
    page.condition.variable_id = originalPage.condition.variable_id
    page.condition.variable_value = originalPage.condition.variable_value

    page.graphic.tile_id = originalPage.graphic.tile_id
    page.graphic.character_name = originalPage.graphic.character_name
    page.graphic.character_hue = originalPage.graphic.character_hue
    page.graphic.direction = originalPage.graphic.direction
    page.graphic.pattern = originalPage.graphic.pattern
    page.graphic.opacity = originalPage.graphic.opacity
    page.graphic.blend_type = originalPage.graphic.blend_type

    page.move_type = originalPage.move_type
    page.move_speed = originalPage.move_speed
    page.move_frequency = originalPage.move_frequency
    page.move_route = originalPage.move_route
    page.walk_anime = originalPage.walk_anime
    page.step_anime = originalPage.step_anime
    page.direction_fix = originalPage.direction_fix
    page.through = originalPage.through
    page.always_on_top = originalPage.always_on_top
    page.trigger = originalPage.trigger
  end

  def self.makeSingleDialoguePage(originalPage, dialogue)
    playerMatcher = InjectionHelper.parseMatcher([:ConditionalBranch, :Switch, proc {|switch| DarkAnaCutscene::CHAR_SWITCHES.include?(switch) }, true])
    spriteMatcher = InjectionHelper.parseMatcher([:SetCharacter, /trChar001_5/i, nil, nil, nil], mapper=InjectionHelper::MOVE_INSNS)

    page = RPG::Event::Page.new

    copyPageDetails(page, originalPage)
    page.condition.switch1_valid = true
    page.condition.switch1_id = Switches[:Ana]

    pushedDialogue = false

    page.list = []
    idx = 0
    dialogueidx = 0

    until idx == originalPage.list.length
      insn = originalPage.list[idx]

      if playerMatcher.matches?(insn)
        nextinsn = originalPage.list[idx + 1]
        until nextinsn.indent == insn.indent &&
            nextinsn.code != InjectionHelper::EVENT_INSNS[:BranchEndConditional] &&
            !playerMatcher.matches?(nextinsn)
          idx += 1
          nextinsn = originalPage.list[idx + 1]
        end

        page.list.push(
          InjectionHelper.parseEventCommand(insn.indent, :ShowText, dialogue[dialogueidx]))
        dialogueidx += 1
      elsif insn.code == InjectionHelper::EVENT_INSNS[:SetMoveRoute]
        insn.parameters[1].list.each { |movecommand|
          movecommand.parameters[0] = 'BGirlwalk_5' if spriteMatcher.matches?(movecommand)
        }
        page.list.push(insn)
      else
        page.list.push(insn)
      end

      idx += 1
    end

    return page
  end

  def self.makeAnaPage(originalPage, dialogue, legacy=nil)
    outfitMatcher = InjectionHelper.parseMatcher([:SetMoveRoute, 2, makeMoveRoute(nil, :Up)])
    spriteMatcher = InjectionHelper.parseMatcher([:SetCharacter, /trChar001_5/i, nil, nil, nil], mapper=InjectionHelper::MOVE_INSNS)

    page = RPG::Event::Page.new

    copyPageDetails(page, originalPage)
    page.condition.switch1_valid = true
    page.condition.switch1_id = Switches[:Ana]

    if !legacy.nil?
      applyGraphic(legacy, legacy ? 66 : 5, page)
    end

    page.list = []
    idx = 0
    dialogueidx = 0
    # Parse original page insns as toxenized
    until idx == originalPage.list.length
      insn = originalPage.list[idx]

      if insn.code == InjectionHelper::EVENT_INSNS[:ShowText] # If text
        nextinsn = originalPage.list[idx + 1]
        until nextinsn.code != InjectionHelper::EVENT_INSNS[:ShowTextContinued]
          idx += 1
          nextinsn = originalPage.list[idx + 1]
        end

        page.list.push(
          InjectionHelper.parseEventCommand(insn.indent, :ShowText, dialogue[dialogueidx]))
        dialogueidx += 1
      elsif outfitMatcher.matches?(insn) # If outfit check
        page.list.push(*InjectionHelper.parseEventCommands(
          [:ConditionalBranch, :Variable, :Outfit, :Constant, 2, :Less],
            [:ControlSwitch, :darkana_AnaLegacy, false],
            [:SetMoveRoute, 2, makeMoveRoute('BGirlWalk_5')],
          :Else,
            [:ConditionalBranch, :Variable, :Outfit, :Constant, 6, :GreaterOrEquals],
              [:ControlSwitch, :darkana_AnaLegacy, false],
              [:SetMoveRoute, 2, makeMoveRoute('BGirlWalk_5')],
            :Else,
              [:ControlSwitch, :darkana_AnaLegacy, true],
              [:SetMoveRoute, 2, makeMoveRoute('BGirlWalk_66')],
            :Done,
          :Done,
          baseIndent: insn.indent))
      elsif insn.code == InjectionHelper::EVENT_INSNS[:SetMoveRoute]
        if insn.parameters[1].list.any? {|movecommand| spriteMatcher.matches?(movecommand) }

          page.list.push(*InjectionHelper.parseEventCommands(
            [:ConditionalBranch, :Variable, :Outfit, :Constant, 2, :Less],
              [:ControlSwitch, :darkana_AnaLegacy, false],
              [:SetMoveRoute, insn.parameters[0], mapMoveRouteToAna(spriteMatcher, insn.parameters[1], 'BGirlWalk_5')],
            :Else,
              [:ConditionalBranch, :Variable, :Outfit, :Constant, 6, :GreaterOrEquals],
                [:ControlSwitch, :darkana_AnaLegacy, false],
                [:SetMoveRoute, insn.parameters[0], mapMoveRouteToAna(spriteMatcher, insn.parameters[1], 'BGirlWalk_5')],
              :Else,
                [:ControlSwitch, :darkana_AnaLegacy, true],
                [:SetMoveRoute, insn.parameters[0], mapMoveRouteToAna(spriteMatcher, insn.parameters[1], 'BGirlWalk_66')],
              :Done,
            :Done,
            baseIndent: insn.indent))
        else
          page.list.push(insn)
        end
      else
        page.list.push(insn)
      end

      idx += 1
    end

    return page
  end

  def self.makeGraphicPage(legacy, darkOutfit, originalPage)
    page = RPG::Event::Page.new

    copyPageDetails(page, originalPage)
    page.condition.switch1_valid = true
    page.condition.switch1_id = Switches[:Ana]

    applyGraphic(legacy, darkOutfit, page)

    return page
  end

  def self.applyGraphic(legacy, darkOutfit, page) 
    if legacy
      page.condition.switch2_valid = true
      page.condition.switch2_id = Switches[:darkana_AnaLegacy]
    end

    page.graphic.character_name = 'BGirlwalk_' + darkOutfit.to_s
  end

  def self.addSingleDialoguePage(event, progress, karmaVar, dialogue)
    idxToInsertAfter = -1
    originalPage = nil
    blockToDelete = nil
    for idx in 0...event.pages.size
      page = event.pages[idx]
      if progress > 0
        next if !page.condition.variable_valid || page.condition.variable_id != karmaVar # KarmaFiles Story
        next if page.condition.variable_value != progress
      else
        next if page.condition.variable_valid && page.condition.variable_id == karmaVar
      end

      if page.condition.switch1_valid && page.condition.switch1_id == Switches[:Ana]
        blockToDelete = page
      else
        idxToInsertAfter = idx
        originalPage = page
      end
    end

    if blockToDelete
      event.pages[event.pages.index(blockToDelete)] = makeSingleDialoguePage(originalPage, dialogue[0])
    elsif idxToInsertAfter != -1
      event.pages.insert(idxToInsertAfter + 1, 
        makeSingleDialoguePage(originalPage, dialogue))
    end
  end

  def self.addAnaPage(event, progress, karmaVar, dialogue)
    idxToInsertAfter = -1
    originalPage = nil
    blockToDelete = nil
    for idx in 0...event.pages.size
      page = event.pages[idx]
      if progress > 0
        next if !page.condition.variable_valid || page.condition.variable_id != karmaVar
        next if page.condition.variable_value != progress
      else
        next if page.condition.variable_valid && page.condition.variable_id == karmaVar
      end

      if page.condition.switch1_valid && DarkAnaCutscene::CHAR_SWITCHES.include?(page.condition.switch1_id)
        idxToInsertAfter = idx
        if page.condition.switch1_id == Switches[:Aevia]
          originalPage = page
        elsif !originalPage
          originalPage = event.pages[idx - 1]
        end
      elsif page.condition.switch1_valid && page.condition.switch1_id == Switches[:Ana]
        blockToDelete = page
      end
    end

    if blockToDelete
      event.pages[event.pages.index(blockToDelete)] = makeAnaPage(originalPage, dialogue)
    elsif idxToInsertAfter != -1
      if originalPage.graphic.character_name[/trChar001_5/i]
        event.pages.insert(idxToInsertAfter + 1, 
          makeAnaPage(originalPage, dialogue, false), 
          makeAnaPage(originalPage, dialogue, true))
      else
        event.pages.insert(idxToInsertAfter + 1, 
          makeAnaPage(originalPage, dialogue))
      end
    end
  end

  def self.addGraphicPage(event)
    idxToInsertAfter = -1
    originalPage = nil
    blockToDelete = nil
    for idx in 0...event.pages.size
      page = event.pages[idx]

      if page.condition.switch1_valid && DarkAnaCutscene::CHAR_SWITCHES.include?(page.condition.switch1_id)
        idxToInsertAfter = idx
        if page.condition.switch1_id == Switches[:Aevia]
          originalPage = page
        elsif !originalPage
          originalPage = event.pages[idx - 1]
        end
      elsif page.condition.switch1_valid && page.condition.switch1_id == Switches[:Ana]
        blockToDelete = page
        end
    end

    if idxToInsertAfter != -1
      event.pages.insert(idxToInsertAfter + 1, 
        makeGraphicPage(false, 5, originalPage), # Desolate
        makeGraphicPage(true, 66, originalPage)) # Desolate Legacy
    end
  end

  def self.patchDesolateOutfit(event)
    for page in event.pages
      insns = page.list
      InjectionHelper.patch(insns, :darkana_patch_desolateoutfit) {
        matched = InjectionHelper.lookForAll(insns,
          [:Script, '$Trainer.outfit=5'])

        for insn in matched
          insn.parameters[0] = 'darkana_determine_outfit_desolate'
        end

        next matched.length > 0
      }
    end
  end

end




def darkana_determine_outfit_desolate
  if $Trainer.metaID == 8 # Ana
    trueOutfit = $game_variables[:Outfit]
    if 2 <= trueOutfit && trueOutfit < 6 
      $game_switches[:darkana_AnaLegacy] = true
      $Trainer.outfit = 66
      return
    end
  end
  $game_switches[:darkana_AnaLegacy] = false
  $Trainer.outfit = 5
end


Events.onMapChanging+=proc {
  if $Trainer && $Trainer.metaID == 8 # Ana
    trueOutfit = $game_variables[:Outfit]
    $game_switches[:darkana_AnaLegacy] = (2 <= trueOutfit && trueOutfit < 6)
  else
    $game_switches[:darkana_AnaLegacy] = false
  end
}

#### INJECTION

class Cache_Game
  if !defined?(darkana_old_map_load)
    alias :darkana_old_map_load :map_load
  end

  def map_load(mapid)
    if @cachedmaps && @cachedmaps[mapid]
      return darkana_old_map_load(mapid)
    end

    ret = darkana_old_map_load(mapid)

    if mapid == 609 # Desolate Inside

      DarkAnaCutscene.addGraphicPage(ret.events[12]) # Player Dupe First
      DarkAnaCutscene.addGraphicPage(ret.events[34]) # Player Dupe
      DarkAnaCutscene.addGraphicPage(ret.events[42]) # Player Dupe Final
      DarkAnaCutscene.patchDesolateOutfit(ret.events[43]) # 100th floor
      DarkAnaCutscene.patchDesolateOutfit(ret.events[13]) # first conversation
      DarkAnaCutscene.patchDesolateOutfit(ret.events[45]) # gain control on 100th floor
      DarkAnaCutscene.patchDesolateOutfit(ret.events[47]) # paradox gate

      DarkAnaCutscene::MAP_609_DIALOGUE.each_pair {|eventId,dialogues|
        event = ret.events[eventId]
        if dialogues.is_a?(Numeric)
          dialogues = DarkAnaCutscene::MAP_609_DIALOGUE[dialogues]
        end
        dialogues.each_pair { |karmaValue,dialogue|
          if karmaValue < 0
            DarkAnaCutscene.addSingleDialoguePage(event, -karmaValue, DarkAnaCutscene::KARMA_GOOD, dialogue)
          else
            DarkAnaCutscene.addAnaPage(event, karmaValue, DarkAnaCutscene::KARMA_GOOD, dialogue)
          end
        }
      }
    elsif mapid == 243 # Desolate Outside
      DarkAnaCutscene.patchDesolateOutfit(ret.events[10]) # M conversation
      DarkAnaCutscene.addGraphicPage(ret.events[30]) # Player Dupe

      DarkAnaCutscene::MAP_243_DIALOGUE.each_pair {|eventId,dialogues|
        event = ret.events[eventId]
        if dialogues.is_a?(Numeric)
          dialogues = DarkAnaCutscene::MAP_243_DIALOGUE[dialogues]
        end
        dialogues.each_pair { |karmaValue,dialogue|
          if karmaValue < 0
            DarkAnaCutscene.addSingleDialoguePage(event, -karmaValue, DarkAnaCutscene::KARMA_BAD, dialogue)
          else
            DarkAnaCutscene.addAnaPage(event, karmaValue, DarkAnaCutscene::KARMA_BAD, dialogue)
          end
        }
      }
      # darkana_patch_desolateoutfit(ret.events[10]) # M Conversation
    end
    return ret
  end
end
