export type Array<T> = { T }
export type Map<K, V> = { [K]: V }

export type Task = () -> ()

export type Props = Map<string, any>

export type Node = {
	className: string,
	props: Props,
	children: Array<Node>,
}

export type Component<T> = (props: Props & T) -> Node

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
