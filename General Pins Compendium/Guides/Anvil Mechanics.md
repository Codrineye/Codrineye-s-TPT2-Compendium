# Anvil Mechanics

The anvil is a circular grid where you can boost effects.<br>
It has four directions corresponding to the four fragment types:<br>
>Offensive (+y)<br>
Defensive (-y)<br>
Utility (-x)<br>
Ultimate (+x)<br>

You use sliders to adjust what fraction of fragments you will invest, from 0.0 to 1.0. This also moves the highlighted "claim circle" accordingly.<br>
You need to invest at least 1 fragment of a type to get boosts of that type to show up.

When you click the hammer or lock icon, the fragment values on the left will be invested into all the boosts within the claim circle.<br>
The amount gained drops off farther from the claim circle's center, and also the primary fragment type (the one that aligns with the boost type) counts for more than the others.<br>
```
The formula is:
new_fragments_distance = (1 - distance * distance / 0.2) ^ 6
new_fragments = old_fragments
new_fragments = new_fragments + new_fragments_distance * primary_frag
new_fragments = new_fragments + new_fragments_distance * other_frag_1 ^ 0.75
new_fragments = new_fragments + new_fragments_distance * other_frag_2 ^ 0.75
new_fragments = new_fragments + new_fragments_distance * other_frag_3 ^ 0.75
```

<details>
  <summary>
    MT15 info
  </summary>
  The perk changes the `^0.75` to `^0.8` in the equation above.<br>
  It also changes the divisor (and the max range) for the distance to 0.25
</details>

The amount of fragments invested is not directly observable.<br>
However, it translates directly into the boost amount, both before and after.<br>
The formulas are
```
For most boosts:
boost = 1 + 0.001 * (invested_frags ^ infinity stone power)
Where resistances are a division boost (boost = 2 => damage taken is now divided by 2)
For cooldown boost:
boost = clamp(0.99 ^ log_10(0.01 * invested_frags ^ infinity stone power))
``` 
The inf stone power is `1.0` if not bought, once bought it changes to `1.1`, for both normal and temporary boosts.

The temporary boost (lock icon) gives more boost, but only lasts until you move the bars - you can't get more permanent boost after.<br>
Also, you keep your fragments.<br>
To calculate temp boosts, take the `new_fragments` amount `^1.25`. This gives a "virtual fragment" amount that, when put through the regular boost formula, gives the temporary boost.

Because of the `^0.75` in the formula, it is best to do multiple, smaller boosts rather than one large boost, at least for the off-fragments.<br>
This is similar to how it is best to do 10% trades in the trading post.
