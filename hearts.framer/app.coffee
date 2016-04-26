{TextLayer} = require 'TextLayer'
{SpriteAnimationLayer} = require "SpriteAnimationLayer"

console.clear()

## vars
$ = Framer
amount = 2

blackHearthback = "#9C89B8"
lovingHearth = "#7D7AC8"
iceHearth = "#F0A6CA"

btn_blackHearthback = "#33343D"
btn_lovingHearth = "#FF78B9"
btn_iceHearth = "#6F9BFC"

dragLeft = -10

backgroundLayer = new BackgroundLayer
	backgroundColor: blackHearthback

## cards
page = new PageComponent
	width: Screen.width, height: Screen.height
	scrollVertical: false
	contentInset: {right: 90}
page.content.backgroundColor = 'transparent'

## generate card layers
for i in [0..amount]
	$["card#{i+1}"] = new Layer 
		backgroundColor: "#FFFADA", borderRadius: 20
		width: page.width-180, height: 550
		x: (page.width+32)*(i+1), y:400, parent: page.content
	$["card#{i+1}"].shadowY = 8
	$["card#{i+1}"].shadowBlur = 18
	$["card#{i+1}"].shadowColor = "rgba(0,0,0,0.2)"
	$["card#{i+1}"].name = "card#{i+1}"
	
	## discription text
	$["labelText#{i+1}"] = new TextLayer
		text: "hearth"
		color: "black"
		textAlign: "center"
		lineHeight:1
		y:340
		fontSize: 62
		width: 300
		fontFamily: 'Nunito'
		superLayer: $["card#{i+1}"]
	$["labelText#{i+1}"].centerX()

$.labelText1.text = "Black oil hearth"
$.labelText2.text = "Loving hearth"
$.labelText3.text = "Cold ice hearth"

page.snapToPage(page.content.subLayers[0])

## hearts

hearth = (name, image_url, steps, speed, parant) ->
	newHearth = new SpriteAnimationLayer
		clip: true
		y: -60
		width: 320
		height: 320
		steps: steps
		speed: speed
		stepsImage: image_url
		parent: parant
		name: name
	newHearth.scale = 2
	newHearth.centerX()
	newHearth.play()

hearth('blackHearth', 'images/black_hearth.png', 48, 0.04, $.card1)
hearth('lovingHearth', 'images/loving_hearth.png', 22, 0.033, $.card2)
hearth('iceHearth', 'images/ice_hearth.png', 48, 0.08, $.card3)

## discription text
discription = new TextLayer
	text: "Chouse your hearth type:"
	color: "white"
	textAlign: "left"
	fontSize: 42
	width: 300
	fontFamily: 'Nunito'
	#borderWidth:4
discription.style =
	'margin': '80px 80px'

btn = new Layer
	y:1100
	backgroundColor: btn_blackHearthback
	borderRadius: 100
	width: 360
	height: 140
btn.centerX()

btnText = new TextLayer
	lineHeight:4.5
	text: "Use"
	fontFamily: 'Nunito'
	fontSize: 42
	color: "white"
	textAlign: 'center'
	superLayer: btn
btnText.center()

page.content.on "change:x", ->
	$.card1.rotation = Utils.modulate(@.x, [-600, 0], [0,20], true)
	$.card2.rotation = Utils.modulate(@.x, [-1400, 0], [0, -80], true)
	$.card3.rotation = Utils.modulate(@.x, [-2200, 0], [0, 100], true)
	if page.content.x is -692
		btn.states.switch('state0')
		backgroundLayer.states.switch('state0')
	if page.content.x is -1474
		btn.states.switch('state1')
		backgroundLayer.states.switch('state1')
	if page.content.x is -2256
		btn.states.switch('state2')
		backgroundLayer.states.switch('state2')

backgroundLayer.states.add
	state0: backgroundColor: blackHearthback
	state1: backgroundColor: lovingHearth
	state2: backgroundColor: iceHearth
backgroundLayer.states.animationOptions =
	time: 1, curve: "ease"

btn.states.add
	state0: backgroundColor: btn_blackHearthback
	state1: backgroundColor: btn_lovingHearth
	state2: backgroundColor: btn_iceHearth
btn.states.animationOptions =
	time: 0.2, curve: "ease"



