export declare interface Props {
    [key: string]: any;

    [Rovo.children]?: Node[];
    [Rovo.ref]?: Ref<any>;
}

export declare interface Node {
    className: string;
    props: Props;
    children: Node[];
}

export type Component = (props?: Props) => Node

export interface Ref<T> {
    current: T;
}

export declare const Rovo: {
    children: string;
    ref: string;

    create(className: string | Component, props?: Props): Node;
    on(event: string): string;
    mount(node: Node, parent: Instance): void;

    state<T>(initialValue: T): [T, (newValue: T) => void];
    useRef<T>(initialValue: T): Ref<T>;
    effect(effect: () => void, dependencies: any[]): void;
}
