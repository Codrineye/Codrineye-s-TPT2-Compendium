This file has been made following the rules specified in the [ROOT LEGEND](/FAQ/README.md)

# Laboratory Experiment: Earth
![Earth Experiment](/FAQ/Images/Earth%20Experiment.png)

# The earth experiment is composed of 3 mechanics
![Earth Experiment UI](/FAQ/Images/Earth%20Experiment%20Main%20UI.png)

## MASS
Mass is required for you to prestige this experiment, it is gained from your drills and determines how much you can compress

## DENSITY
In this experiment, your goal is to gain as much density as possible<br>
All rewards for the earth experiment are locked behind a density requirement<br>
Your compressor, depending on your selected mode, will increase your density by compressing (decreasing) the radius and volume of the obtained mass

## WHAT'S WITH THE ON, OFF SWITCHES
If you're looking at the earth experiment for the first time, you might be asking why you wouldn't keep both drills and the compressor on simultaniously<br>
Well, while you **could** try to use them simultaneously, you should note the following 2 aspects of compressing:
- If you gain mass while compressing, your compression is decreased in accordance to the amount of mass you gained.
- While using a mode that's not Quick & Dangerous, the drills slow down the closer your compressor gets to the maximum compression possible.

Please be aware that the section that follows will talk more about this maximum I'm refering to:
- Switching the drills off, while you will have to do very rarely, is beneficial in the early levels as the compressor might startup too slowly
- Switching the compressor off is needed to be able to change the mode of your compressor

# There are 4 factors to the compressor
- Compressor Modes: [Redirecting to what these modes do](#what-do-these-modes-do)
- Compressor Limit
- Compressor Activation/Deactivation
- Compressor Stability: [Redirecting to why stability matters](#why-should-i-care-about-stability)

There are 3 modes, Quick & Qangerous, Slow & Safe, Stabilize<br>
The compressor is controlled by the player via the green bar<br>
The red bar is controlled by the compressor and cannot surpass this green bar

![Control Bars](/FAQ/Images/Earth%20Experiment%20Control%20Bars.png)

The green bar represents the maximum speed the compressor can achieve, the bigger the bar, the quicker it'll run<br>
The red bar is the progress the compressor has made in its startup/shutdown sequence, it slowly builds up to the maximum when active and slowly drains to the minimum when deactivated<br>
While compressing, you _ALWAYS_ lose stability, the modes are ordered from most stability drain to least stability drain

# What do these modes do?
![Earth Experiment Modes](/FAQ/Images/Earth%20Experiment%20Compressor%20Modes.png)

## Mode 1: Quick & Dangerous
This mode compresses your mass in the fastest way, with the drawback that it **also** drains the stability the fastest

## Mode 2: Slow & Safe
This mode compresses mass in a way such that you can leave it running and you are unlikely to run out of stability before you check on it again, but remember... **THIS MODE STILL DRAINS STABILITY**, it just drains it a lot slower than quick and dangerous

## Mode 3: Stabilize
This mode does not compress your mass, instead, it increases your compresors stability

# Why should I care about stability?
Stability is a crucial part of this experiment<br>
If your stability drops to 0% you will have to reset your experiment, which will cause you to lose:
- **ALL** your mass
- **ALL** your density*
- **ALL** the progress inside of your drills

It is important to note that, tho your experiment needs to be reset, you still retain all density before you start your drills back up<br>
thanks to this, you are still able to collect your rewards if you're observant enough

# What happens when I prestige?
You got enough mass to prestige, congratulations<br>
On first prestige, you will be met with the prestige screen

![Earth Experiment Prestige](/FAQ/Images/Earth%20Experiment%20Prestige%20Screen.png)

If you hover over the middle icon, you will learn what performing a prestige has reset<br>
**Keep in mind that this menu can be accessed whenever you'd like, you do not need to prestige to see these effects**<br>
You are able to avoid this reset if you buy the exotic skill called `Fundementals`<br>
This experiment has 2 prestige upgrades:
- **Left Improvement**: Reduces the stability loss during compression by 20% and increases stability regeneration in stabilize mode by 10% (Multiplicative)
- **Right Improvement**: Increases the speed at which the compression bar adjust by 30% and raises the mass produced by drills by 12% (Multiplicative)

These upgrades have 50 levels each<br>
It is recommended that you invest your prestige points into the **Right Improvement** as a quicker startup/shutdown sequence leads to less stability loss<br>
Once you feel comfortable with the speed at which your compressor bars fill up, you can take the **Left Improvement** as it permits the usage of Quick & Dangerous for a longer period of time

# The experiments formulas
Do note that this information will hardly ever come in usefull, but it's better to have a dedicated space for it, thank you matt for telling us this information<br>
On the bright side, it could help you understand it better

[density](#density) = [mass](#mass) / volume<br>
[mass](#mass) is a double, meaning that its limit is ~1e308, meaning 10<sup>308</sup><br>
volume = 4/3 \* pi \* radius<sup>3</sup><br>
radius = uncompressed radius \* (1.0 - compression)<br>
max.compression = 10 - 0.5 \* clamp01(0.75<sup>log<sub>3</sub>mass</sup>)

clamp01(x) is equivalent to max(0, min(x, 1))<br>
clamp01(x) means:<br>
- if x < 0, it outputs 0
- if x > 1, it outputs 1
