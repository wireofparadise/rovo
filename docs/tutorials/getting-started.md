# Getting started

## Rendering some text

=== "Luau"

    ```luau
    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Rovo = require(ReplicatedStorage.Packages.Rovo)

    Rovo.mount(
        Rovo.create("ScreenGui", {
            ResetOnSpawn = false,

            [Rovo.children] = {
                Rovo.create("TextLabel", {
                    Text = "Hello, world!",
                    Size = UDim2.fromOffset(200, 50)
                })
            }
        }),

        Players.LocalPlayer.PlayerGui
    )
    ```

=== "TypeScript"

    ```luau
    import { Players } from "@rbxts/services";
    import { Rovo, type Ref, type Node } from "@rbxts/rovo";

    Rovo.mount(
        Rovo.create("ScreenGui", {
            ResetOnSpawn: false,

            [Rovo.children]: [
                Rovo.create("TextLabel", {
                    Text: "Hello, world!",
                    Size: UDim2.fromOffset(200, 50)
                })
            ]
        }),

        Players.LocalPlayer.PlayerGui
    );
    ```

## Connecting events

=== "Luau"

    ```luau
    -- ...

    Rovo.create("TextButton", {
        Text = "Hello, world!",
        Size = UDim2.fromOffset(200, 50),

        [Rovo.on("MouseButton1Down")] = function()
            print("Clicked!")
        end
    })

    -- ...
    ```

=== "TypeScript"

    ```luau
    -- ...

    Rovo.create("TextButton", {
        Text: "Hello, world!",
        Size: UDim2.fromOffset(200, 50),

        [Rovo.on("MouseButton1Down")]: () => {
            print("Clicked!")
        }
    });

    -- ...
    ```

## Stateful component with side-effects

=== "Luau"

    ```luau
    -- ...
    
    type CounterProps = {
        Position: UDim2,
        AnchorPoint: Vector2,
    }

    local function Counter(props: CounterProps): Rovo.Node
        local count, setCount = Rovo.state(0)
        local frameRef: Rovo.Ref<Frame?> = Rovo.createRef(nil)

        Rovo.effect(function()
            print("Count has just changed!")
            print("By the way, here is a reference to the currently rendered component instance!", frameRef.current)
        end, { count })

        return Rovo.create("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.fromOffset(0, 0),
            AutomaticSize = Enum.AutomaticSize.XY,
            Position = props.Position,
            AnchorPoint = props.AnchorPoint,

            [Rovo.ref] = frameRef,

            [Rovo.children] = {
                Rovo.create("UIListLayout", {}),

                Rovo.create("TextLabel", {
                    Text = "Count: " .. tostring(count),
                    Size = UDim2.fromOffset(200, 50),
                }),

                Rovo.create("TextButton", {
                    Text = "Click",
                    Size = UDim2.fromOffset(200, 50),

                    [Rovo.on("MouseButton1Down")] = function()
                        setCount(count + 1)
                    end
                })
            }
        })
    end

    Rovo.mount(
        Rovo.create("ScreenGui", {
            ResetOnSpawn = false,

            [Rovo.children] = {
                Rovo.create(Counter, {
                    Position = UDim2.fromScale(0.5, 0.5),
                    AnchorPoint = Vector2.new(0.5, 0.5)
                })
            }
        }),

        Players.LocalPlayer.PlayerGui
    )
    ```

=== "TypeScript"

    ```ts
    // ...

    interface CounterProps {
        Position: UDim2;
        AnchorPoint: Vector2;
    }

    function Counter(props: CounterProps): Node {
        const [count, setCount] = Rovo.state(0);
        const frameRef = Rovo.createRef<Frame | undefined>(undefined);

        Rovo.effect(() => {
            print("Count has just changed!")
            print("By the way, here is a reference to the currently rendered component instance!", frameRef.current)
        }, [count]);

        return Rovo.create("Frame", {
            BackgroundTransparency: 1,
            Size: UDim2.fromOffset(0, 0),
            AutomaticSize: Enum.AutomaticSize.XY,
            Position: props.Position,
            AnchorPoint: props.AnchorPoint,

            [Rovo.ref]: frameRef,

            [Rovo.children]: [
                Rovo.create("UIListLayout", {}),

                Rovo.create("TextLabel", {
                    Text: `Count: ${count}`,
                    Size: UDim2.fromOffset(200, 50),
                }),

                Rovo.create("TextButton", {
                    Text: "Click",
                    Size: UDim2.fromOffset(200, 50),

                    [Rovo.on("MouseButton1Down")]: () => {
                        setCount(count + 1);
                    }
                })
            ]
        });
    }

    Rovo.mount(
        Rovo.create("ScreenGui", {
            ResetOnSpawn: false,

            [Rovo.children]: [
                Rovo.create(Counter, {
                    Position: UDim2.fromScale(0.5, 0.5),
                    AnchorPoint: new Vector2(0.5, 0.5)
                })
            ]
        }),

        Players.LocalPlayer.PlayerGui
    );
    ```
