defmodule QueueTest do
  use ExUnit.Case

  test "new queue" do
    assert Queue.new() == %Queue{front: [], rear: []}
  end

  test "push to queue" do
    q = Queue.new()
    assert Queue.push(q, 1) == %Queue{front: [1], rear: []}
  end

  test "pushr to queue" do
    q = Queue.new()
    assert Queue.pushr(q, 1) == %Queue{front: [], rear: [1]}
  end

  test "push and pop from queue" do
    q = Queue.new()
    |> Queue.push(1)
    |> Queue.push(2)
    |> Queue.push(3)
    |> Queue.push(4)
    assert Queue.pop(q) == { 4, %Queue{front: [3, 2], rear: [1]} }
  end

  test "push and popr from queue" do
    q = Queue.new()
    |> Queue.push(1)
    |> Queue.push(2)
    |> Queue.push(3)
    |> Queue.push(4)
    assert Queue.popr(q) == { 1, %Queue{front: [4, 3], rear: [2]} }
  end

  test "pushr and popr from queue" do
    q = Queue.new()
    |> Queue.pushr(1)
    |> Queue.pushr(2)
    |> Queue.pushr(3)
    |> Queue.pushr(4)
    assert Queue.popr(q) == { 4, %Queue{front: [1], rear: [3, 2]} }
  end

  test "pop from empty queue" do
    q = Queue.new()
    assert Queue.pop(q) == :empty
  end

  test "peek queue" do
    q = Queue.new()
    |> Queue.push(1)
    |> Queue.push(2)
    assert Queue.peek(q) == { :ok, 2 }
  end

  test "peekr queue" do
    q = Queue.new()
    |> Queue.push(1)
    |> Queue.push(2)
    assert Queue.peekr(q) == { :ok, 1 }
  end

  test "peek empty queue" do
    q = Queue.new()
    assert Queue.peek(q) == :empty
  end

  test "push and drop from queue" do
    q = Queue.new()
    |> Queue.push(1)
    |> Queue.push(2)
    |> Queue.push(3)
    |> Queue.push(4)
    assert Queue.drop(q) == %Queue{front: [3, 2], rear: [1]}
  end

  test "push and dropr from queue" do
    q = Queue.new()
    |> Queue.push(1)
    |> Queue.push(2)
    |> Queue.push(3)
    |> Queue.push(4)
    assert Queue.dropr(q) == %Queue{front: [4, 3], rear: [2]}
  end
end
