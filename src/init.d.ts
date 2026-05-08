export declare interface Props {
    [key: string]: any;

    [Rovo.children]?: Node[];
    [Rovo.ref]?: Ref<any>;
}

export declare interface Node<T extends Props = Props> {
    className: string;
    props: T;
    children: Node[];
}

export type Component<T extends Props> = (props: T) => Node

export interface Ref<T> {
    current: T;
}

export declare const Rovo: {
    children: string;
    ref: string;

    create<T extends Props>(className: string | Component<T>, props: T): Node;
    on(event: string): string;
    mount(node: Node, parent: Instance): void;

    state<T>(initialValue: T): [T, (newValue: T) => void];
    useRef<T>(initialValue: T): Ref<T>;
    effect(effect: () => void, dependencies: any[]): void;
}
