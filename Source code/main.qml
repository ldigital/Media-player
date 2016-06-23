import QtQuick 2.3
import QtQuick.Controls 1.2
import QtMultimedia 5.5
import QtQuick.Dialogs 1.2
import QtQml 2.2
import cpp_interface_module 1.0
import QtQuick.Dialogs 1.2

ApplicationWindow {
    id: applicationWindow1
    visible: true
    width: 640
    height: 480
    color: "#daddef"
    minimumWidth: 480
    minimumHeight: 480
    title: qsTr("Leon Media Player")

    menuBar: MenuBar {
        Menu {
            title: qsTr("File")
            MenuItem {
                text: qsTr("&Open")
                onTriggered:
                {
                    file_dialog.visible = true
                }
            }

            MenuItem {
                text: qsTr("About")
                onTriggered:
                {
                    about_dialog_box.visible = true
                }
            }

            MenuItem {
                text: qsTr("Exit")
                onTriggered: Qt.quit();
            }
        }
    }

    Rectangle {
        id: loadMediaScreen
        width: 730
        color: "#3949cf"
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0
        SequentialAnimation on color {
               loops: Animation.Infinite
               ColorAnimation { to: "#3949cf"; duration: 5000 }
               ColorAnimation { to: "red"; duration: 5000 }
           }


        Text {
            id: text1
            x: applicationWindow1.width/2 - 110
            y: applicationWindow1.height/2 - 150
            width: 220
            height: 30
            color: "#ededed"
            text: qsTr("Play your media:")
            visible: true
            font.underline: true
            font.pixelSize: 30
        }

        Text {
            id: text2
            x: applicationWindow1.width/2 - 140
            y: applicationWindow1.height/2 - 100
            width: 294
            height: 27
            color: "#ededed"
            text: qsTr("Image files (such as jpeg)")
            visible: true
            font.italic: true
            font.pixelSize: 25
            NumberAnimation on x{
                from: 0
                to: applicationWindow1.width/2 - 140
                duration: 600
            }
        }

        Text {
            id: text3
            x: applicationWindow1.width/2 - 140
            y: applicationWindow1.height/2 - 50
            width: 284
            height: 27
            color: "#ededed"
            text: qsTr("Audio files (such as mp3)")
            visible: true
            font.italic: true
            font.pixelSize: 25
            NumberAnimation on x{
                from: applicationWindow1.width
                to: applicationWindow1.width/2 - 140
                duration: 600
            }
        }

        Text {
            id: text4
            x: applicationWindow1.width/2 - 140
            y: applicationWindow1.height/2
            width: 285
            height: 27
            color: "#ededed"
            text: qsTr("Video files (such as mp4)")
            visible: true
            font.italic: true
            font.pixelSize: 25
            NumberAnimation on x{
                from: 0
                to: applicationWindow1.width/2 - 140
                duration: 600
            }
        }

        Text {
            id: text5
            x: applicationWindow1.width/2 - 150
            y: applicationWindow1.height/2 + 60
            color: "#ededed"
            text: qsTr("Load my media")
            font.pointSize: 25
            font.bold: true
            visible: true
            font.pixelSize: 41
            MouseArea{
                anchors.fill: parent
                onClicked: file_dialog.visible = true
            }
            NumberAnimation on y{
                loops: Animation.Infinite
                from: applicationWindow1.height/2 +40
                to: applicationWindow1.height/2 + 50
                easing.type: Easing.InOutExpo
                duration: 600
            }
        }
}
    Cpp_interface {
        id: cppClass
        onValueChanged: { //receive a signal emitting every second from c++ class member (time_format()) and use that to update values...
            current_time_elapsed.text = cppClass.get_time_elapsed_output
            sliderHorizontal1.accessibleIncreaseAction()

        }
    }

    FileDialog {    //by default should be invisible, then made visible from desired location
        id: file_dialog
        title: "Please choose a file"
        onAccepted: {
            loadMediaScreen.visible = false
            mediaScreen.visible = true
            stop.visible = true
            current_time_elapsed.visible = true
            sliderHorizontal1.visible = true
            media_duration.visible = true
            play_pause.visible = true
            pictureViewer.source = file_dialog.fileUrl
            medplayer.source = file_dialog.fileUrl
            medplayer.play()
        }
    }


    Rectangle {
        id: mediaScreen
        color: "black"
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 66
        anchors.top: parent.top
        anchors.topMargin: 0
        visible: false

        //media player vs audio & video types, is that MediaPlayer provides meta-data that is not available to video type...
        MediaPlayer { //for mediaplayer type video playback, both the MediaPlayer and VideoOutput declarations should be children of the area to display, in this case rectangle
            id: medplayer
            onHasVideoChanged: {
                cppClass.get_media_duration = medplayer.duration
                cppClass.time_format()
                media_duration.text = cppClass.get_media_duration_output
                cppClass.get_is_media_paused = false
                playPauseButtonImage.source = "qrc:/pause.png"
            }

            onHasAudioChanged: {
                cppClass.get_media_duration = medplayer.duration
                cppClass.get_is_media_paused = false
                playPauseButtonImage.source = "qrc:/pause.png"
            }

        }

        VideoOutput {
            y: 0
            width: 480
            height: 669
            anchors.rightMargin: 0
            anchors.bottomMargin: 0
            anchors.leftMargin: 0
            anchors.topMargin: 0
            anchors.fill: parent
            source: medplayer //output neeeds to be linked to MediaPlayer object
        }

        Image {
            id: pictureViewer
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.top: parent.top
            anchors.topMargin: 0
        }

     }

    Button {
        id: stop
        y: 425
        width: 45
        height: 45
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        anchors.left: parent.left
        anchors.leftMargin: 8
        visible: false
        onClicked:{
            medplayer.stop()
            cppClass.timer_stop()
            cppClass.timer_reset()
            sliderHorizontal1.value = 0 //set slider to decrease
            playPauseButtonImage.source = "qrc:/play.png"
        }
        Image {
            anchors.fill: parent
            visible: true
            source: "qrc:/stop.png"
        }
    }

    Button {
        id: play_pause
        y: 425
        width: 45
        height: 45
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        anchors.left: parent.left
        anchors.leftMargin: 64
        visible: false
        onClicked: {
            if(cppClass.get_is_media_paused === false && medplayer.hasAudio === true)
            {
               medplayer.pause()
               playPauseButtonImage.source = "qrc:/play.png"
               cppClass.get_is_media_paused = true
               cppClass.timer_stop()
               console.log("paused")
            }

            else if(cppClass.get_is_media_paused === true && medplayer.hasAudio === true)
            {
               medplayer.play()
               playPauseButtonImage.source = "qrc:/pause.png"
               cppClass.get_is_media_paused = false
               cppClass.timer_start()
               console.log("not paused")

            }

        }
        Image {
            id: playPauseButtonImage
            anchors.fill: parent
            source: "qrc:/play.png"
        }
    }


    Slider {
        id: sliderHorizontal1
        y: 436
        height: 22
        anchors.right: parent.right
        anchors.rightMargin: 81
        anchors.left: parent.left
        anchors.leftMargin: 185
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 22
        stepSize: 1.0   //sets the slider movement rate
        maximumValue: medplayer.duration /1000  // breaks the media duration into seconds
        visible: false
        onPressedChanged: { //this controls what happens when slider moved.
            cppClass.get_time_elapsed = sliderHorizontal1.value  //update the current time display with slider position
            medplayer.seek(sliderHorizontal1.value * 1000)  //use the same slider value to seek in the media
        }
    }

     Text { //current elapsed time
         id: current_time_elapsed
         y: 438
         width: 51
         height: 19
         text: qsTr("--:--:--")
         anchors.bottom: parent.bottom
         anchors.bottomMargin: 23
         anchors.left: parent.left
         anchors.leftMargin: 121
         opacity: 0.9
         font.pixelSize: 13
         visible: false
     }

     Text { //duration
         id: media_duration
         x: 572
         y: 438
         width: 51
         height: 19
         text: qsTr("--:--:--")
         anchors.right: parent.right
         anchors.rightMargin: 17
         anchors.bottom: parent.bottom
         anchors.bottomMargin: 23
         opacity: 0.9
         font.pixelSize: 12
         visible: false
     }

     MessageDialog {
     id: about_dialog_box
     title: "About"
     text: "Ldigital Media Player

            Version 1.0

            This application was designed and written by
            Leon Harvey (a.k.a Ldigital)

            Not for distribution purposes."
     }
}










