' ********** Copyright 2015 Roku Corp.  All Rights Reserved. **********

Sub RunUserInterface()
    screen = CreateObject("roSGScreen")
    scene = screen.CreateScene("HomeScene")
    port = CreateObject("roMessagePort")
    screen.SetMessagePort(port)
    screen.Show()

    oneRow = GetApiArray()
    ' print oneRow[0]
    list = [
        {
            TITLE : "First row"
            ContentList : oneRow
        }
        {
            TITLE : "Second row"
            ContentList : oneRow
        }
        {
            TITLE : "Third row"
            ContentList : oneRow
        }
    ]
    scene.gridContent = ParseXMLContent(list)


    while true
        msg = wait(0, port)
        print "------------------"
        print "msg = "; msg
    end while

    if screen <> invalid then
        screen.Close()
        screen = invalid
    end if
End Sub


Function ParseXMLContent(list As Object)
    RowItems = createObject("RoSGNode","ContentNode")

    for each rowAA in list
    'for index = 0 to 1
        row = createObject("RoSGNode","ContentNode")
        row.Title = rowAA.Title

        for each itemAA in rowAA.ContentList
            ' print rowAA.ContentList[itemAA]
            item = createObject("RoSGNode","ContentNode")
            ' We don't use item.setFields(itemAA) as doesn't cast streamFormat to proper value
            for each key in itemAA
                item[key] = itemAA[key]
            end for

            row.appendChild(item)
        end for
        RowItems.appendChild(row)
    end for

    return RowItems
End Function


Function GetApiArray()
    url = CreateObject("roUrlTransfer")
    url.SetUrl("http://fc-devices.s3.amazonaws.com/roku/flicast/json/demo_home_content.json")
    rsp = url.GetToString()
    data = ParseJSON(rsp)
    ' print data.categories[0].items[0]
    result = []

    for each thing in data.categories[0].items
      item ={}
      item.stream = {url:thing.streamURL}
      item.url = thing.streamURL
      item.streamFormat = "mp4"
      ' print thing.thumbPic
      item.HDPosterUrl = "pkg:/images/"+thing.thumbPic
      ' print item.HDPosterUrl
      item.hdBackgroundImageUrl = "pkg:/images/"+thing.thumbPic
      ' print item
      result.push(item)
    end for

    ' print result[]

    ' responseXML = ParseXML(rsp)
    ' responseXML = responseXML.GetChildElements()
    ' responseArray = responseXML.GetChildElements()
    '

    '
    ' for each xmlItem in responseArray
    '     if xmlItem.getName() = "item"
    '         itemAA = xmlItem.GetChildElements()
    '         if itemAA <> invalid
    '             item = {}
    '             for each xmlItem in itemAA
    '                 item[xmlItem.getName()] = xmlItem.getText()
    '                 if xmlItem.getName() = "media:content"
    '                     item.stream = {url : xmlItem.url}
    '                     item.url = xmlItem.getAttributes().url
    '                     item.streamFormat = "mp4"
    '
    '                     mediaContent = xmlItem.GetChildElements()
    '                     for each mediaContentItem in mediaContent
    '                         if mediaContentItem.getName() = "media:thumbnail"
    '                             item.HDPosterUrl = mediaContentItem.getattributes().url
    '                             item.hdBackgroundImageUrl = mediaContentItem.getattributes().url
    '                         end if
    '                     end for
    '                 end if
    '             end for
    '             result.push(item)
    '         end if
    '     end if
    ' end for
    '
     return result
End Function


Function ParseXML(str As String) As dynamic
    if str = invalid return invalid
    xml=CreateObject("roXMLElement")
    if not xml.Parse(str) return invalid
    return xml
End Function
