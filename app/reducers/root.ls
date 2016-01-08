{sample} = require 'lodash'
mc = require 'material-colors'
require! {
	'../actions/action-names': actions
	'./reducers':{reduce-tick,reduce-history}
	'./mfd-reducer': {reduce-mfd}
	'../constants/constants': {ROAD-LENGTH,COLORS,VF,NUM-CARS,RUSH-LENGTH,TRIP-LENGTH}
	'prelude-ls':{map,flatten,each,even}
	lodash: {random,assign}
}

# INITIALIZE WAITING CARS
cars = [til NUM-CARS]
	|> map (i) -> 
		entry-loc = random(0,ROAD-LENGTH)
		res = 
			id: i
			fill: sample COLORS
			trip-length: TRIP-LENGTH + random(-100,100)
			t-a: 0
			t-e: 0
			exited: false
			place: -1
			move: 0
			cum-move: 0
			entry-time: RUSH-LENGTH*i/NUM-CARS

initial-state = 
	time: 0
	cars: cars
	paused: true
	traveling: []
	waiting: [...cars]
	cycle: 100
	green: 60
	offset: 20
	num-signals: 25
	mfd:[]
	history: []

combined = reduce-mfd >> reduce-history

root = (state,action)->
	window.a = state
	switch action.type
	case actions.SET-CYCLE
		combined {...state,cycle: action.cycle}
	case actions.SET-OFFSET
		combined {...state,offset: action.offset}
	case actions.SET-GREEN
		combined {...state,green: action.green}
	case actions.SET-NUM-SIGNALS
		num-signals = action.num-signals
		combined {...state,num-signals}
	case actions.PAUSE-PLAY
		paused = !state.paused
		{...state, paused}
	case actions.TICK
		# for i in [til 2]
		state = reduce-tick state
		state
	default state

export {root,initial-state}
