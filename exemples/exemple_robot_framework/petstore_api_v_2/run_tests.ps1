# Runs this example's suite with all Robot Framework reports written to its own results/ folder,
# instead of wherever the command happens to be invoked from.
param([string[]]$RobotArgs)
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
robot --outputdir "$here\results" @RobotArgs "$here\test"
