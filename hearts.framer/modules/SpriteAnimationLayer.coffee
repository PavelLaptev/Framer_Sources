# Created By Jordan Dobson | @jordandobson | jordandobson@gmail.com
# Find out more info about this module at http://framerco.de/post/132696470374/module-sprite-animation-layer-this-module-helps

class exports.SpriteAnimationLayer extends Layer

	constructor:(@options) ->
		# Check and make sure we have the properties we need 
		return @errorForMissingProperties() if @isMissingProperties()
		
		# Instance Vars
		@sprite = @cells = @animation = @isPlaying = @shouldOnlyPlayOnce = null
		
		# Setup Sprite Object
		@sprite = 
			width:  @options.width
			height: @options.height
			steps:  @options.steps
			image:  @options.stepsImage
			speed:  @options.speed || 0.1
			activeStep: 1
		
		# Setup @options and call super
		@options.backgroundColor = "transparent"
		super @options

		# Create Cells & Animation Object
		@setupCellsLayer()
		@setupAnimation()

		# Create Click Event for Frame to DEBUG
		# @setupClickForFrameOutline()
		
	# Setup Methods ##############################################################
	
	setupCellsLayer: =>
		@cells = new Layer
			width:  @sprite.width * @sprite.steps
			height: @sprite.height
			image: @sprite.image
			superLayer: @
			
	setupAnimation: =>
		@animation = new Animation
			layer: @cells,
			properties: 
				x: @activeStepCellsPositionX()
			time: 0
			curve: "linear"
			
		@cells.on Events.AnimationStart, (animation) =>
			# Check we don't start animation when we should be stopped
			@animation.stop() unless @isPlaying

		@cells.on Events.AnimationEnd, (animation) =>
			# Set the activeStep on the sprite object
			if @sprite.activeStep < @sprite.steps 
				@sprite.activeStep++
			else
				@sprite.activeStep = 1
				# Check if we should only play once
				if @shouldOnlyPlayOnce
					@shouldOnlyPlayOnce = false
					return
			# Update the animation with a new x position
			@animation.options.properties.x = @activeStepCellsPositionX()
			@animation.options.delay = @sprite.speed
			# Play next frame if we aren't stopped
			@animation.start() if @isPlaying
			
	# Animation Helper Methods ###################################################
	
	activeStepCellsPositionX: => 
		return -( @sprite.width * (@sprite.activeStep - 1) )

	play: => 
		@isPlaying = true
		@animation.start()
		
	playOnce: => 
		@isPlaying = true
		@shouldOnlyPlayOnce = true
		@play()
		
	pause: =>
		@isPlaying = false
		@animation.stop()

	# Error & Debug methods ######################################################

	setupClickForFrameOutline: =>
		@.on Events.Click, -> @.clip = !@.clip
		@.style = "outline": "1px solid red"

	isMissingProperties: =>
		return (
			!@options? or 
			!@options.width? or 
			!@options.height? or 
			!@options.steps? or 
			!@options.stepsImage?
			)
		
	errorForMissingProperties: =>
		error null
		console.error "You must pass the properties width, height, steps & stepsImage to the new SpriteAnimation."
		return
