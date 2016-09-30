
sub Main()
  mainInit()
end sub

sub mainInit()

  print "Main Init"
  screen = CreateObject("roSGScreen")
  scene = screen.CreateScene("LandingPage")
  port = CreateObject("roMessagePort")
  screen.setMessagePort(port)

  screen.show()

  'needed for keeping the app alive'
	while true
		msg = wait(0, port)
	end while

	if screen <> invalid then
		screen.Close()
		screen = invalid
	end if

end sub
