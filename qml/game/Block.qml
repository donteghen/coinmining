import Felgo 3.0
import QtQuick 2.0


EntityBase {
  id: block

  // allow entitymanager-pooling of entities
  entityType: "block"
  poolingEnabled: true

  // hide block if outside of game area
  enabled: opacity == 1

  // each block knows its type and position on the field
  property int type
  property int row
  property int column

  property int previousRow
  property int previousColumn

  // emit a signal when block should be swapped with another
  signal swapBlock(int row, int column, int targetRow, int targetColumn)
  signal swapFinished(int row, int column, int swapRow, int swapColumn)
  signal fallDownFinished(var block)

  // show different images for block types
  Image {
    anchors.fill: parent
    source: {
      if (type == 0)
        return "../../assets/img/fruits/Bitcoin.png"
      else if(type == 1)
        return "../../assets/img/fruits/Red.png"
      else if (type == 2)
        return "../../assets/img/fruits/Green.png"
      else if (type == 3)
        return "../../assets/img/fruits/Blue.png"
      else if (type == 4)
        return "../../assets/img/fruits/Turquoise.png"
      else if (type == 5)
        return "../../assets/img/fruits/DeepMagenta.png"
      else if (type == 6)
        return "../../assets/img/fruits/ethereum.png"
      else
        return "../../assets/img/fruits/DeepBlue.png"
    }
  }

  // handle mouse events to initialize swapping of blocks when dragging
  MouseArea {
    id: mouse
    anchors.fill: parent

    // properties to handle dragging
    property bool dragging
    property bool waitForRelease
    property var dragStart

    // start drag on press
    onPressed: {
      if(!dragging && !waitForRelease) {
        dragging = true
        dragStart = { x: mouse.x, y: mouse.y }
      }
    }
    // stop drag on release
    onReleased: {
      dragging = false
      waitForRelease = false
    }
    // trigger swap of blocks after player swiped a certain distance
    onPositionChanged: {
      if(!dragging || waitForRelease)
        return

      var xDistance = mouse.x - dragStart.x
      var yDistance = mouse.y - dragStart.y

      if((Math.abs(xDistance) < block.width/2)
          && (Math.abs(yDistance) < block.height/2))
        return

      var targetRow = block.row
      var targetCol = block.column

      if(Math.abs(xDistance) > Math.abs(yDistance)) {
        if(xDistance > 0)
          targetCol++
        else
          targetCol--
      }
      else {
        if(yDistance > 0)
          targetRow++
        else
          targetRow--
      }

      // signal block move
      dragging = false
      waitForRelease = true
      block.swapBlock(row, column, targetRow, targetCol)
    }
  }

  // rectangle for highlight effect
  Rectangle {
    id: highlightRect
    color: "white"
    anchors.fill: parent
    anchors.centerIn: parent
    opacity: 0
    z: 1
  }

  // particle effect
  Item {
    id: particleItem
    width: parent.width
    height: parent.height
    x: parent.width/2
    y: parent.height/2

    Particle {
      id: sparkleParticle
      fileName: "../particles/FruitySparkle.json"
    }
    opacity: 0
    visible: opacity > 0
    enabled: opacity > 0
  }

  // fade out block before removal
  NumberAnimation {
    id: fadeOutAnimation
    target: block
    property: "opacity"
    duration: 500
    from: 1.0
    to: 0

    // remove block after fade out is finished
    onStopped: {
      sparkleParticle.stop()
      entityManager.removeEntityById(block.entityId)
    }
  }

  // fade out block before removal
  NumberAnimation {
    id: fadeInAnimation
    target: block
    property: "opacity"
    duration: 1000
    from: 0
    to: 1
  }

  // animation to let blocks fall down
  NumberAnimation {
    id: fallDownAnimation
    target: block
    property: "y"
    onStopped: {
      fallDownFinished(block)
    }
  }

  // timer to wait with fall-down until other blocks fade out
  Timer {
    id: fallDownTimer
    interval: fadeOutAnimation.duration
    repeat: false
    running: false
    onTriggered: {
      fallDownAnimation.start()
    }
  }

  // timer to wait a bit before signal swap finished
  Timer {
    id: signalSwapFinished
    interval: 50
    onTriggered: swapFinished(block.previousRow, block.previousColumn, block.row, block.column)
  }

  // animation to move a block after swipe
  NumberAnimation {
    id: swapAnimation
    target: block
    duration: 150
    onStopped: {
      signalSwapFinished.start() // trigger swapFinished
    }
  }

  // animation for highlighting a block
  SequentialAnimation {
    id: highlightAnimation
    loops: Animation.Infinite
    NumberAnimation {
      target: highlightRect
      property: "opacity"
      duration: 750
      from: 0
      to: 0.35
    }
    NumberAnimation {
      target: highlightRect
      property: "opacity"
      duration: 750
      from: 0.35
      to: 0
    }
  }

  // start fade out / removal of block
  function remove() {
    particleItem.opacity = 1
    sparkleParticle.start()
    fadeOutAnimation.start()
  }

  // trigger fall down of block
  function fallDown(distance) {
    // complete previous fall before starting a new one
    fallDownAnimation.complete()

    // move with 100 ms per block
    // e.g. moving down 2 blocks takes 200 ms
    fallDownAnimation.duration = 100 * distance
    fallDownAnimation.to = block.y + distance * block.height

    // wait for removal of other blocks before falling down
    fallDownTimer.start()
  }

  // function to move block one step left/right/up or down
  function swap(targetRow, targetCol) {
    swapAnimation.complete()

    block.previousRow = block.row
    block.previousColumn = block.column

    if(targetRow !== block.row) {
      swapAnimation.property = "y"
      swapAnimation.to = block.y +
          (targetRow > block.row ? block.height : -block.height)
      block.row = targetRow
    }
    else if(targetCol !== block.column) {
      swapAnimation.property = "x"
      swapAnimation.to = block.x +
          (targetCol > block.column ? block.width : -block.width)
      block.column = targetCol
    }
    else
      return

    swapAnimation.start()
  }

  // highlights the block to help the player find groups
  function highlight(active) {
    if(active) {
      highlightRect.opacity = 0
      highlightAnimation.start()
    }
    else {
      highlightAnimation.stop()
      highlightRect.opacity = 0
    }
  }

  // fade in
  function fadeIn() {
    fadeInAnimation.start()
  }
}
