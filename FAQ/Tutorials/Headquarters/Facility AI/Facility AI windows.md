# What is a Custom AI Overlay

![Facility AI Interface Visuals](/FAQ/Images/Facility%20AI%20Interface%20Visual.png)
A custom AI Overlay is a "window" you can create to provide a visual interface to the actions being performed by an AI.<br>
To access your created windows, you have to move to the "Visual" tab, which is found next to the settings icon at the top right of the Facility AI interface.

## The AI Overlay Builder

![AI Overlay Builder](/FAQ/Images/AI%20Overlay%20Builder.png)

By hitting `NEW`, you open up the AI Overlay Builder. <br>
Inside this editor you can click the title `AI Overlay Builder: title` to change the name of the window or add new components to your window.

To create a visual interface, you create a `child to parent` hirearchi, where you declair a parent component and attatch child components to it.

There are 5 components you can chose from, each having adjustable settings that you can access by clicking on the component<br>
Every component contains an ID field and a size field:

The ID field is used to give the sellected component a name used in the AI editor to modify the target component.

The size field is used to define the size of this component, you declair the size on the x axis, and by adding a space you declair the size on the y axis.<br>
Here's an example since it's not easy to explain, if you want a button that's 5 long and 5 wide, you'd give it the size of `5 5`, <b>not</b> `5,5` or `5;5`

## Image

The image component is symbolised by a ship and it lets you display a single image.

The `Sprite (Icon)` field represents what image it's displaying, clicking it will open a menu with all usable sprites<br>
To change its sprite in code, you will have to use the sprites ID, seen when you hover over the image in the menu.

The `Color` field is a hexadecimal color code for the sprite, changing this field will change the colors of your sprite.

`Preserve Aspect` is a checkbox that makes the image preserve its aspect ratio when stretched.

Note that at the time of writing this, this components Size field doesn't change unless it's direct parent is a [containter](#containers).

## Text

The text component is symbolised by `txt` and lets you display text.

The `Content` field is the text that this component will display.

The `Text Alignment` field is a dropdown box of how the text will be displayed.

Note that at the time of writing this, this component cannot be the parent of other components.

## Button

The button component is symbolised by an orange box and it creates a pressable button.

The `Sprite (Icon)` field and `Color` fields are identical to the ones found in [The image component](#image).

The `Script (Triggered on click)` field contains the name of the script that will be activated once the button is pressed.<br>
Keep in mind that if your script is within a package, you have to input the same name you would when executing a script in the [AI editor](Facility%20AI%20Scripting.md).

The `Impulse (Emitted on click)` field contains the impulse that will be given to the triggered AI when the button is pressed.<br>
This value is returned by the string function `triggered impulse`.

## Containers

The container component has 2 forms, with the same adjustable settings:
* The horisontal container will displace its child components horisontally
* The vertical container will displace its child components vertically

The `Color (Background)` field is a hexadecimal value representing what color is behind their child components.

The `Padding` field is an integer that determines by how much the child components x and y size values will be shrunk by.

The `Spacing` field is an integer that determines how much space is used between child components

`Content Size Fitter` is a checkbox that increases the size of all its child components to the size of the largest child component

# Space management

The AI overlay builder grants you a total of 10.000 characters of XML. For most projects, this should be more than enough, but if you're looking to create complex windows, this limitation can get in your way, so here are a few tips to make your window building experience as pleasent as possible.

## Leave components to their default values

A component comes with its default values inside of its fields. If you change the contents of these fields, you now get the name of the field you've modified in addition to the modified value.

This can be confusing, as adding a button comes with all fields besides the Sprite (Icon) and Color empty<br>
Sprite (Icon) always takes space, as it needs to point to its sprite, but the color field holds a completely different story.

The button color is `#FFFFFF` by default, but you could think that it'd be better to shrink it to `#FFF` instead, as it's the same color but in 4 characters instead of the usual 7. You have, however, done the opposite, as `#FFFFFF` adds 0 extra data to your xml code, but by changing it to `#FFF` you've added the attribute ` color="#FFF"`, adding 13 extra characters by just removing 3.

## Use Containers

Containers are great components for organization, but if you use them well, they can be used to remove a lot of attributes.<br>

