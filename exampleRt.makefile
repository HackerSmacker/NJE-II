all: nje.route

nje.route: njeroutes.netinit njeroutes.header
	../bin/njeroutes njeroutes.header njeroutes.netinit
