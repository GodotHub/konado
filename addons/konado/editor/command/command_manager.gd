extends Command
class_name CommandManage
## 命令管理器

var history   :=100  ## 撤销步数
var undo_stack:=[]   ## 撤销操作列表
var redo_stack:=[]   ## 重做列表

func execute_command(command: Command):
	command.execute()
	undo_stack.append(command)
	if undo_stack.size() > history:   # 限制历史记录长度
		undo_stack.pop_front()
	redo_stack.clear() # 清空重做列表
func undo():
	var inf:String 
	if undo_stack.size() > 0:
		var command = undo_stack.pop_back()
		command.undo()
		redo_stack.append(command)
	elif undo_stack.size()> history:
		inf ="已经达到最大撤销步数"
		print(inf)
	else:
		inf ="没有可以撤销的操作"
		print(inf)

func redo():
	var inf:String ="没有可以重做的操作"
	if redo_stack.size() > 0:
		var command = redo_stack.pop_back()
		command.redo()
		undo_stack.append(command)
	else:
		print(inf)
