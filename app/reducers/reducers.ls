pl = require 'prelude-ls'
_ = require 'lodash'
{VF,W,STEP,ROAD-LENGTH,STEP} = require '../constants/constants'

reduce-history = (state)->
	{cars,mfd} = state
	V = d3.scale.linear()
		.domain( mfd |>pl. map (.k))
		.range( mfd |> pl.map (.v))

	waiting = [...cars]
	traveling = []
	history = {}
	time = 0
	cum-move = 0
	lines = [{time,cum-move}]
	places = [til ROAD-LENGTH] |> pl.map -> -1

	while (waiting.length>0 or traveling.length>0) and time<7000
		n0 = traveling.length
		v = V n0/ROAD-LENGTH
		move = v*STEP
		cum-move+=move

		[traveling,exits] = traveling 
		|> pl.map (car)->
			{...car,cum-move: car.cum-move+move}
		|> pl.partition (car)->
			car.cum-move<=car.trip-length

		exits |> pl.each (car)->
			car.t-e = time
			places[car.place] = -1

		[arrivals,waiting] = waiting
		|> pl.partition -> it.entry-time<=time

		arrivals |> pl.each (car)->
			car.t-a = time
			my-place = car.place = places 
			|> _.find-index _,(d)-> d == -1
			places[my-place] = car.id

		q = v*n0/ROAD-LENGTH
		k = n0/ROAD-LENGTH

		traveling = pl.concat [traveling,arrivals]
		history[time] = {time,q,k,traveling}
		time+=STEP
	{...state,history}

reduce-tick = (state)->
	time = STEP + state.time
	traveling = state.history[time].traveling #can do this lookup in an arry because the step was 1
	{...state,traveling,time}

export {reduce-tick,reduce-history}