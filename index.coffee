debug =console.log
debug 'hello world'

DAY =256
PORT =8081

modules =
	fs: require 'fs'
	path: require 'path'
	http: require 'http'
	url: require 'url'

main =
	asdf: 111
	days: [ 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 ]
	days_leap: [ 31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 ]
	init: ->
		debug 'main initialized', @asdf
		@server =modules .http .createServer @server_handler .bind( @ )
		@server .listen PORT
	process_year: ( year )->
		is_leap =@check_leap( year )
		debug year, is_leap
		days =if is_leap then @days_leap else @days
		day =DAY
		month =0
		for count in days
			break if day - count < 0
			day -=count
			month +=1
		obj =
			errorCode: 200
			dataMessage: "#{ day + 1 }/#{ month + 1 }/#{ year }"
	process_date: ( date )->
		target =
			day: parseInt date .substr 0, 2
			month: parseInt date .substr 2, 2
			year: parseInt date .substr 4, 4
		is_leap =@check_leap( target .year )
		days =if is_leap then @days_leap else @days
		day =DAY
		month =0
		after =false
		for count in days
			#break if day - count < 0
			if month ==target .month - 1
				after =true
				day -=target .day
			day -=count unless after
			month +=1
		if day < 0
			year_days =if is_leap then 366 else 365
			day =year_days + day
		obj =
			date: target
			dataMessage: day
	server_handler: ( request, response )->
		url =modules .url .parse request .url, true
		obj =if url .query .year
			@process_year url .query .year
		else if url .query .currentDate
			@process_date url .query .currentDate
		#response .end( "#{ @check_leap( year ) } #{ day + 1 }/#{ month + 1 }/#{ year }\n" )
		response .end JSON .stringify( obj, null, 2 ) + "\n"
	check_leap: ( year )->
		return true if year % 400 == 0
		return false if year % 100 == 0
		return true if year % 4 == 0
		return false

main .init()

