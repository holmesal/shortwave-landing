'use strict'

# Am I proud of this code? No. A thousand times no. But it only took me two beers to write, and god damn it, it works.
# Also, snap svg is kind of a piece of shit. I mean, I keep trying it, but I always end up just animating svg path strings at the end of the day.

angular.module('earshotApp')
	.directive('peeps', ($window) ->
		template: '<svg id="svg" ng-style="style"></svg>'
		restrict: 'E'
		scope: 
			person: '@'
		link: (scope, element, attrs) ->
			# element.text 'this is the peeps directive'

			scope.peeps = {}

			setHeight = =>
				# Get the height
				w = angular.element $window
				scope.style = 
					height: w.height() / 2

				console.log "Height is #{scope.style.height}"

				# Figure out about how many children to add
				scope.numPeeps = Math.floor Math.min(w.height(), w.width())/80
				console.log "Creating #{scope.numPeeps} peeps"

			initSnap = ->
				# Get the svg element
				svgElem = element[0].children[0]
				scope.s = s = Snap svgElem

			initPeeps = ->
				console.dir element[0].children[0].clientHeight
				for num in [0...scope.numPeeps]
					randPos = getRandomPos true
						
					# randPos =
					# 	x: 100
					# 	y: 0
					scope.peeps[num] = new Person randPos, scope.s

			getRandomPos = (preDraw=false) ->
				offset = 0
				turn = 0
				maxTurns = 20
				while offset < 150
					turn++
					console.log 'offset!'
					testPos = 
						x: Math.random() * (element[0].children[0].clientWidth - 100)
						y: Math.random() * (scope.style.height - 100)
					testOffset = 999999
					for id, peep of scope.peeps
						if preDraw
							endPos = peep.pos
						else
							endPos = peep.g.getBBox()
						dist = calcDistance testPos, endPos
						if dist < testOffset
							testOffset = dist
					offset = testOffset
					if turn > maxTurns
						break
				return testPos

			calcDistance = (from, to) ->
				Math.abs(to.x - from.x) + Math.abs(to.y - from.y)

			showPeeps = =>
				for id, peep of scope.peeps
					randTime = Math.random() * 500 + 2000
					peep.show randTime

			class Person

				constructor: (@pos, @s) ->
					console.log "Created new person at position #{pos.x}, #{pos.y}"

					# Load the svg
					Snap.load scope.person, (f) =>
						# Initial attributes
						elem = f.selectAll()

						# Append
						@g = f.select 'g'
						@g.attr
							transform: "t#{@pos.x},#{@pos.y}s0,0"
							opacity: 1
						@g.selectAll('path').attr
							fill: '#FFFFFF'
						@g.selectAll('circle').attr
							fill: '#FFFFFF'
							# fill: 'white'
						# g.transform
						# 	globalMatrix: [200,200]
						@s.append @g
						console.log @g.getBBox().x
						console.log @pos.x

				show: (timeout) ->
					console.log 'showing peep!'
					# @s.append @elem
					setTimeout =>
						@g.animate
							# scale: 1
							transform: "t#{@pos.x},#{@pos.y}s0.3,0.3"
							opacity: 1
						, 400, mina.elastic, =>
							# Start the interval for the messages
							@startSendingMessages()
							# Start drifting
							# @walk()
					, timeout

				startSendingMessages: ->
					offset = Math.random() * 2000
					frequency = Math.random() * 5000 + 2000
					setTimeout =>
						setInterval @sendMessages, frequency
					, offset

				drift: ->
					dest = 
						x: Math.random() * 50 - 25
						y: Math.random() * 50 - 25
					@g.animate
						transform: "t#{@pos.x + dest.x},#{@pos.y + dest.y}s0.3,0.3"
					, 5000, =>
						@drift()

				tryWalk: =>
					unless @walking
						if Math.random() > 0.8
							@walk()

				walk: ->
					@walking = true
					
					dist = 1000
					tries = 0
					maxTries = 10
					# Is it kinda nearby?
					while dist > 300
						tries++
						# Get a new valid position
						newPos = getRandomPos()
						dist = calcDistance(newPos, @g.getBBox())
						if tries > maxTries
							break
					# Go there
					@pos = newPos
					@g.animate
						# scale: 1
						transform: "t#{@pos.x},#{@pos.y}s0.3,0.3"
					, 1000, mina.easeinout, =>
						@walking = false


				sendMessages: =>
					# Find all the people within range
					for id, peep of scope.peeps
						dist = calcDistance @g.getBBox(), peep.g.getBBox()
						if dist < 500
							# Send a message to this person by drawing a line
							line = @s.line @g.getBBox().x+15, @g.getBBox().y+15, peep.g.getBBox().x+15, peep.g.getBBox().y+15
							line.attr
								stroke: '#FFFFFF'
								strokeWidth: 1
								opacity: 0.3
							line.animate
								opacity: 0
							, 300, ->
								@remove()

					# Maybe walk around?
					setTimeout @tryWalk, 1000



			setHeight()
			initSnap()
			initPeeps()
			showPeeps()


	)
