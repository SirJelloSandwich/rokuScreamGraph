' ********** Copyright 2016 Roku Corp.  All Rights Reserved. **********

' 1st function that runs for the scene on channel startup
sub init()
  ' 'To see print statements/debug info, telnet on port 8089
  print "LANDING PAGE INIT"

  m.xTrans = 100
  m.xSpacing =20
  m.top.setFocus(true)
  m.fliPoster={}
  m.fliPoster.width = 336
  m.fliPoster.height = 210

  m.fliBorder = {}
  m.fliBorder.width =5
  m.index = 0

  m.poster = []
  m.label = []
  m.ppp = m.xTrans

  m.rowSlideAmount = m.fliPoster.width+m.xSpacing

  for iii=0 to 10

    m.poster[iii] = m.top.createChild("Poster")
    m.label[iii] = m.top.createChild("Label")
    m.label[iii].text = "Movie"
    m.label[iii].translation =[m.ppp, 240]
    m.poster[iii].uri = "pkg:/images/channel-poster_hd.png"
    m.poster[iii].height = m.fliPoster.height
    m.poster[iii].width = m.fliPoster.width
    m.poster[iii].translation = [m.ppp, 20]
    m.ppp = m.ppp + m.poster[iii].width + m.xSpacing
  end for

  m.initialBorderPos = m.poster[m.index].boundingRect()

  createBorder(m.initialBorderPos, m.fliBorder.width)
end sub

sub moveRow(selected)
   currX = m.xTrans
   manageSelectedElement(m.poster[selected], m.label[selected])
   selected = selected or m.index
   setLeftItemPositions(selected - 1, currX)
   currX = m.poster[selected].width + 120
   setRightItemPositions(selected + 1, currX)

end sub

sub manageSelectedElement(selectedEle, selectedLabel)
  selectedEle.translation = [100, 20]
  selectedLabel.translation=[100, 240]
end sub

sub setLeftItemPositions(start, currX)

    currPosition = 0
    itemTrans = [0,0]
    for i = start to 0 step -1
      currPosition = (currX - m.poster[i].width - m.xSpacing)

      itemTrans = [currPosition, 20]
      m.poster[i].translation = itemTrans
      m.label[i].translation = [currPosition, 240]
      '
      ' if (this.elementWidths[i] > 0) {
      '   this.$rowElements[this.rowCounter][i].style[this.transformStyle] = itemTrans;
      '   //this.$rowElements[this.rowCounter][i].style.opacity = "";
      '
      ' } else {
      '   //keep element offscreen if we have no width yet
      '   this.$rowElements[this.rowCounter][i].style[this.transformStyle] = "translate3d(" + (-this.transformLimit) + "px,0,0px)";
      '   this.$rowElements[this.rowCounter][i].style.display = "none";
      '
      ' }
      '
      ' if (currX < -this.transformLimit + 1000) {
      '   if (this.limitTransforms) {
      '     break;
      '   }
      ' } else {
       currX = currX -  (m.poster[i].width + m.xSpacing)
      '
      ' }
    end for
end sub

sub setRightItemPositions(start, currX)
  for i = start to m.poster.count()-1 step 1
    if m.poster[i].width > 0
      m.poster[i].translation = [currX, 20]
      m.label[i].translation = [currX, 240]
    ' //  this.$rowElements[this.rowCounter][i].style.opacity = "";
    ' } else {
    '   //keep element offscreen if we have no width yet
    '   this.$rowElements[this.rowCounter][i].style[this.transformStyle] = "translate3d(" + this.transformLimit + " +px,0,0px)";
    ' }
    '
    ' if (currX > this.transformLimit+1000) {
    '   if (this.limitTransforms) {
    '     break;
    '   }
    ' } else {
      currX = currX + (m.poster[i].width + m.xSpacing)

    ' }
    end if

    end for
end sub



sub moveBorder(index, direction)
  ' currX = m.poster[index-1].boundingRect()
if direction>0
  eleData = m.poster[index].boundingRect()
  myCurr = m.poster[index-1].boundingRect()

  move = m.border.translation[0]+myCurr.width+m.xSpacing
  m.border.translation= [move,0]
end if

if direction <0
eleData = m.poster[index].boundingRect()
myCurr = m.poster[index+1].boundingRect()

move = m.border.translation[0]-eleData.width-m.xSpacing
m.border.translation= [move,0]
end if


end sub

sub createBorder(borderData, borderWidth)

    m.border = m.top.createChild("Rectangle")
    m.borderTop = m.border.createChild("Rectangle")
    m.borderTop.width = borderData.width
    m.borderTop.height = borderWidth
    m.borderTop.color ="#ff0000"
    m.borderTop.translation = [borderData.x, borderData.y]

    m.borderLeft = m.border.createChild("Rectangle")
    m.borderLeft.width = borderWidth
    m.borderLeft.height = borderData.height+borderWidth
    m.borderLeft.color ="#ff0000"
    m.borderLeft.translation = [borderData.x, borderData.y]

    m.borderBottom = m.border.createChild("Rectangle")
    m.borderBottom.width = borderData.width
    m.borderBottom.height = borderWidth
    m.borderBottom.color ="#ff0000"
    m.borderBottom.translation = [borderData.x, borderData.height+borderData.y]

    m.borderRight = m.border.createChild("Rectangle")
    m.borderRight.width = borderWidth
    m.borderRight.height = borderData.height+borderWidth
    m.borderRight.color ="#ff0000"
    m.borderRight.translation = [borderData.width+borderData.x, borderData.y]

end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
  print "OnkeyEvent"
  result = true
  print "LANDING PAGE onKeyEvent ";key;" "; press
  if press then
    if key = "right"
      if m.index < m.poster.count()-1
        m.index = m.index+1
        ' ?m.index
        moveBorder(m.index, 1)
        ' moveRow(m.index)
      end if

    end if
    if key="left"
        if m.index >=1
          m.index = m.index-1
            ' moveRow(m.index)
          moveBorder(m.index, -1)
        end if

    end if

  end if
  return result
end function
