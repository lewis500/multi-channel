react = require 'react'
d3 = require 'd3'
{Q0,KJ,ROAD-LENGTH} = require '../constants/constants'
{svg,circle,path,rect,g,line} = react.DOM
require '../style/style-charts.scss'
# require '../style/style-'
{connect} = require 'react-redux'
pl = require 'prelude-ls'
[width,height] = [1050,150]
color = d3.scale.category20()
# git remote add origin https://github.com/lewis500/multi-channel.git
# git push -u origin master

m = 
	t: 0
	l: 20
	b: 30
	r: 5

x-scale = d3.scale
	.linear()
	.domain [0,ROAD-LENGTH]
	.range [0,width]

y-scale = d3.scale
	.linear()
	.domain [0,400]
	.range [0,80]

xAxis = d3.svg
	.axis()
	.scale x-scale
	.ticks 5

yAxis = d3.svg
	.axis()
	.scale y-scale
	.orient 'left'

path-maker = d3.svg
	.line()
	.x (.time)>>x-scale
	.y (.val)>>y-scale

ACCEL = 0.010
faller-fun = (d,time)->
	res = 0.5*ACCEL*(time - d.t-a)^2
	pl.min height,res

make-rect = (d,time,i)->
	rect do 
		do ->
			y = y-scale(d.trip-length - d.cum-move)
			a
			res = 
				className: \car
				# height: \3px
				height: y
				width: width/ROAD-LENGTH - 0.2
				key: d.id
				y: faller-fun( d,time) - y
				x: x-scale d.place
				fill: color( d.place)
				place: d.place
			
Drop-Chart = react.create-class do
	componentDidMount: ->
		d3.select @refs.xAxis	.call xAxis
	render: ->
		{traveling,time} = @props

		svg do
			do
				id: 'drop-chart'
				width: width+m.l+m.r
				height: height+m.t+m.b
			g do
				transform: "translate(#{m.l},#{m.t})"
				rect do
					do
						width: width
						height: height
						className: \bg
				g do
					className: 'g-rects'
					traveling |> _.map _,(car,i)->
						make-rect car,time,i

				g className:'x axis',ref: 'xAxis',transform: "translate(0,#{height})"

|> connect -> it{traveling,time}
|> react.create-factory

export Drop-Chart
