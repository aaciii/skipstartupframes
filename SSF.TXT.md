## The `ssf.txt` format

The `ssf.txt` file format consists of line definitions of rom names combined with frame numbers to be skipped for that rom. When the a game is loaded in MAME, the plugin loads `ssf.txt` and looks for the rom to determine how many frames to skip. The format is as follows:

`<rom_name>,<startup_frames>`

```
...
radm,14
radr,79
radrad,439
raflesia,15
ragnagrd,243
raiden,42
raiden2,30
raiders,550
raiders5,1443
raimais,529
rainbow,376
rallybik,517
rallyx,760
...
```

For any given game, if it's frame target is missing from `ssf.txt`, it will default to `0`.

## DO NOT EDIT `ssf.txt`

Nothing bad will happen, but if you make changes/customizations to `ssf.txt`, they will be overwritten if you install a new version of this plugin. Instead, add customizations to `ssf_custom.txt`

## `ssf_custom.txt`

Any customizations to frame numbers should be added to `ssf_custom.txt`. The format is the exact same as `ssf.txt`. Additionally, any changes made to frames in the Plugin Options menu in MAME will be saved to `ssf_custom.txt`.

A rom entry in `ssf_custom.txt` WILL TAKE PRIORITY over the same rom entry in `ssf.txt`.

For example:

- `ssf.txt` contains `galaga,870`
- You add `galaga,900` to `ssf_custom.txt`
- When starting up `galaga` the plugin will skip `900` frames instead of `870`

## Startup vs. Soft Reset

A small number of games go through different procedures with a _startup_ (or _hard reset_) vs. a _soft reset_. Sometimes a _soft reset_ requires a different number of frames that must be skipped. An example of this is the 1984 arcade game _Zwackery_.

- A _startup_ is when you initially start a game with MAME
- A _soft reset_ is when you press F3, which instantly resets the game
- A _hard reset_ is when you press SHIFT+F3, which exits the game and immediately starts it up again

This plugin treats a _startup_ and _hard reset_ the same but a _soft reset_ differently.

To faciliate different frame values for _soft resets_, `ssf.txt` and `ssf_custom.txt` both support an additional _optional_ format:

`<rom_name>,<startup_frames>|<reset_frames>`

Example: `zwackery,750|120`

When starting up `zwackery` 750 frames will be skipped. If a _soft reset_ occurs, only 120 frames will be skipped.

## `ssf.txt` Contributions and Updates

`ssf.txt` is an old file that was [created back in 2004](https://forum.arcadecontrols.com/index.php/topic,48674.msg).

The majority of startup frames are most likely still accurate from 2004 but a lot can change in 20+ years. Some new roms have been added to MAME. Some old roms might have been changed or redumped. If you find any startup frames in `ssf.txt` to be inaccurate or missing, you can easily contribute changes to the project so everyone can use them.

Clone the repository, commit your changes to `ssf.txt` and create a pull request back to the `develop` branch of this repository. If approved, changes will make their way into a future release of the plugin.

Don't commit changes to `ssf_custom.txt`. It is not to be included in distribution of the plugin in order to prevent overwriting anyone's customizations.
