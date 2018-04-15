# some helper functions

set_irq_priority_ff () {
	IRQ_NAME=$1
	IRQ_PRIORITY=$2

	# get the IRQ number from /proc/interrupts
	IRQ_ID=`grep $IRQ_NAME /proc/interrupts | awk '{print $1}' | sed 's/://'`

	# get the IRQ PID
	# todo: check if PID exists (checl IRQ_PID has 2 lines before last awking)
	IRQ_PID=`ps -eLo pid,cmd | grep "\[irq/$IRQ_ID-.*\]" | head -n -1 | awk 'NR==1{print $1}'`

	# set the PID to the correct priority
	chrt -f -p $IRQ_PRIORITY $IRQ_PID
}