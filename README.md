![Game Screenshot](imgs/readme_topimage.png)

---

# NPC System

## 📚 Overview
This repo contains a library that allows you to create NPCs that you can interact with. Built for Stormworks: Build and Rescue.

Utilizes [Aurora Framework by Cuh4](https://github.com/Cuh4/AuroraFramework).

## 😔 Limitations
- NPCs are not persistent. If you create a NPC, and then reload the addon, the NPC will have to be created again
- To start a conversation with a NPC, you can only say one thing. After that, you can say multiple things to progress through the conversation depending on the NPC's dialog.
- Dialogs cannot be natively linked to one another. Each dialog has their own route.

## ❓ Requirements
- **Python 3.11+**
- **Stormworks: Build and Rescue** (game)

## 💻 Setup
1) Run `git clone "https://github.com/cuhHub/NPC-System.git"`
2) Create a `playlist.xml` file containing the content below.
```xml
<?xml version="1.0" encoding="UTF-8"?>
<playlist file_store="4" name="Addon Name Here">
    <locations>
        <locations/>
    </locations>
</playlist>
```
3) Run `py combiner.py` (or run `combiner.bat`) to create a `script.lua` file. Feel free to close it once it has been created.
4) Run `sync.bat` to automatically replicate the addon into your Stormworks' addons folder.
5) Create a save with the addon enabled.

## ✨ Credit
- [**Cuh4**](https://discord.com/users/1141077132915777616) ([GitHub](https://github.com/Cuh4))