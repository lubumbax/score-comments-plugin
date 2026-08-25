# Score Comments (MuseScore 4 Plugin)

A simple dockable panel plugin for MuseScore 4 that allows you to add internal annotations, notes, or comments to your score project. The comments are saved within a hidden text element attached to the score and are not visible on the printed or exported sheet music.

## Features

*   **Dockable Panel:** Integrates seamlessly into the MuseScore 4 interface.
*   **Auto-saving & Undo Support:** Comments are automatically saved to the score as a hidden element as you type, allowing native (Undo/Redo) integration.
*   **Score Sync:** The text area automatically updates to show the comments of the currently active score tab.
*   **Invisible on Print:** Comments are stored internally as an invisible `StaffText` element, keeping your printed score clean.

## Installation

1.  Download the `Score Comments.qml` file and the `Score Comments.png` icon file.
2.  Place both files in your MuseScore 4 plugins directory. The typical locations are:
    *   **Windows:** `%HOMEPATH%\Documents\MuseScore4\Plugins`
    *   **macOS:** `~/Documents/MuseScore4/Plugins`
    *   **Linux:** `~/Documents/MuseScore4/Plugins`
3.  Open MuseScore 4.
4.  Navigate to **Home > Plugins** (or use the Plugin Manager).
5.  Find "Score Comments" in the list and click the toggle to enable it.

## Usage

1.  Open a score in MuseScore 4.
2.  Go to **Plugins > Score Comments** in the top menu bar to open the dockable panel.
3.  Type your notes or annotations into the text area. The comments are saved automatically shortly after you stop typing.
4.  If you switch to another open score tab, the panel will automatically load and display the comments associated with that specific score.

## Compatibility

*   Requires MuseScore 4.x (Tested on MuseScore 4.x API)
