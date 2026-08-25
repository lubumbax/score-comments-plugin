import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import MuseScore 3.0

MuseScore {
    menuPath: "Plugins.Score Comments"
    description: "Dockable panel to store multi-line internal annotations inside the score."
    version: "1.0"
    thumbnailName: "Score Comments.png"
    pluginType: "dock"
    requiresScore: true

    property string currentScoreId: ""
    property string signature: "[[SCORE_COMMENTS]]\n"

    function getCommentElement(score) {
        if (!score) return null;
        var cursor = score.newCursor();
        cursor.rewind(0); // Rewind to the very first segment of the score
        while (cursor.segment) {
            for (var i = 0; i < cursor.segment.annotations.length; i++) {
                var ann = cursor.segment.annotations[i];
                if (ann.type === Element.STAFF_TEXT && ann.text && ann.text.indexOf(signature) === 0) {
                    return ann;
                }
            }
            break; // Only check the very first segment of the score
        }
        return null;
    }

    function readComments(score) {
        if (!score) return "";
        var el = getCommentElement(score);
        if (el) {
            return el.text.substring(signature.length);
        }
        return "";
    }

    function writeComments(score, text) {
        if (!score) return;
        var el = getCommentElement(score);
        if (el) {
            if (el.text.substring(signature.length) === text) {
                // Ensure it's transparent and autoplace is off even if created earlier
                if (el.visible === false || el.color !== "#00000000" || el.autoplace !== false) {
                    score.startCmd();
                    el.visible = true;
                    el.color = "#00000000";
                    el.autoplace = false;
                    score.endCmd();
                }
                return;
            }
            score.startCmd();
            el.text = signature + text;
            el.visible = true;
            el.color = "#00000000"; // fully transparent
            el.autoplace = false; // prevents taking up layout space
            score.endCmd();
        } else {
            if (text === "") return; // Don't create an element for empty text
            score.startCmd();
            el = newElement(Element.STAFF_TEXT);
            el.text = signature + text;
            el.visible = true;
            el.color = "#00000000"; // fully transparent instead of invisible
            el.autoplace = false; // prevents taking up layout space
            
            var cursor = score.newCursor();
            cursor.rewind(0);
            cursor.add(el);
            
            score.endCmd();
        }
    }

    // Triggered when the dock is initially opened
    onRun: {
        if (curScore) {
            textArea.text = readComments(curScore);
            currentScoreId = curScore.scoreName;
        }
    }

    // Timer to detect tab switches and external score changes (like Undo/Redo)
    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            if (curScore) {
                if (curScore.scoreName !== currentScoreId) {
                    currentScoreId = curScore.scoreName;
                    textArea.text = readComments(curScore);
                } else if (!textArea.activeFocus && !debounceSaveTimer.running) {
                    var currentComments = readComments(curScore);
                    if (textArea.text !== currentComments) {
                        textArea.text = currentComments;
                    }
                }
            } else {
                currentScoreId = "";
                textArea.text = "";
            }
        }
    }

    Item {
        anchors.fill: parent

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 10

            Label {
                text: "Score Comments"
                font.bold: true
                font.pointSize: 10
            }

            ScrollView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true

                TextArea {
                    id: textArea
                    wrapMode: TextArea.Wrap
                    placeholderText: "Type score comments here...\n\nThese comments are saved as a hidden element in the score, enabling native Undo/Redo."
                    
                    // Restart the save timer whenever the user types something
                    onTextEdited: {
                        debounceSaveTimer.restart();
                    }
                }
            }
        }
    }

    // Debounce timer: Saves the data 600ms after the user stops typing
    Timer {
        id: debounceSaveTimer
        interval: 600
        repeat: false
        onTriggered: {
            if (curScore) {
                writeComments(curScore, textArea.text);
            }
        }
    }
}