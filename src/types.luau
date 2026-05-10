export type Array<T> = { T }
export type Map<K, V> = { [K]: V }

export type Task = () -> ()

export type Props = Map<string, any> & {
	Children: Children?,
	Ref: Ref<any>?,
}

export type Node = {
	className: string,
	props: Props,
}

export type Children = Array<Node>

export type Component = (props: Props) -> Node

export type Fiber = {
	node: Node,
	parent: Instance,
	children: Array<Fiber>,
	hooks: Array<any>,
	hookIndex: number,
	instance: Instance?,
	isAlive: boolean,
	isUpdateScheduled: boolean,
}

export type Ref<T> = {
	current: T,
}

export type Effect = {
	cleanup: () -> ()?,
	dependencies: Array<any>?,
}

return nil
