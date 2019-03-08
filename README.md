# Example app for Redix.PubSub issue #132

https://github.com/whatyouhide/redix/issues/132

### Install deps and compile:

```
mix do deps.get, compile
```

### Launch iex:

```
iex -S mix
#=> #PID<0.184.0> The pub/sub listener is subscribed to: "my-channel"
```

### Check the state of PubSub connection:

```
:sys.get_state(PubSub.Connection)
#=> {:connected,
#=>   %Redix.PubSub.Connection{
#=>     ...
#=>     pending_subscriptions: %{},
#=>     subscriptions: %{{:channel, "my-channel"} => #MapSet<[#PID<0.184.0>]>},
#=>     }
#=>   }
#=> }
```

### Kill PubSub for "my-channel":

```
send(PubSub.MyChannel, :die)

#=> [error] GenServer PubSub.MyChannel terminating
#=> #PID<0.194.0> The pub/sub listener is subscribed to: "my-channel"
```

Supervisor started new process instead of crashed one. It should subscribe to "my-channel" in init callback (you can see the log message).

### Check the state of PubSub connection again:

```
:sys.get_state(PubSub.Connection)
#=> {:connected,
#=>   %Redix.PubSub.Connection{
#=>     ...
#=>     pending_subscriptions: %{{:channel, "my-channel"} => #MapSet<[#PID<0.194.0>]>},
#=>     subscriptions: %{},
#=>     }
#=>   }
#=> }
```

As you can see newly started #PID<0.194.0> remains in `:pending_subscriptions`, and does not receive messages from channel any more.
