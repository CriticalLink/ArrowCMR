package require cmdline
set options {\
	{ "project.arg" "" "Project name" }
}
array set opts [::cmdline::getoptions quartus(args) $options]

if { ![project_exists $opts(project)] } {
	post_message -type error "Project $opts(project) does not exist"
	exit
}

load_package report

project_open $opts(project)

load_report

set panel_name "Timing Analyzer||Multicorner Timing Analysis Summary"

set num_panel_cols [get_number_of_columns -name $panel_name]
set failing false

for {set i 1} {$i < $num_panel_cols} {incr i} {
	set slack [get_report_panel_data -name $panel_name -row_name "Worst-case Slack" -col $i]
	set type [get_report_panel_data -name $panel_name -row 0 -col $i]
	puts "Worst-case $type: $slack"
	if {$slack < 0} {
		set failing true
		break
	}
}
puts [expr $failing?"Design Failed Timing":"Design Passed Timing"]
unload_report
project_close

if { $failing } {
	exit -2
}
