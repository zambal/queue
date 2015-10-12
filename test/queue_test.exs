defmodule QueueTest do
  use ExUnit.Case

  defp push_1_4 do
    Queue.new()
    |> Queue.push(1)
    |> Queue.push(2)
    |> Queue.push(3)
    |> Queue.push(4)
  end

  defp pushr_1_4 do
    Queue.new()
    |> Queue.pushr(1)
    |> Queue.pushr(2)
    |> Queue.pushr(3)
    |> Queue.pushr(4)
  end

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
    q = push_1_4
    assert Queue.pop(q) == { 4, %Queue{front: [3, 2], rear: [1]} }
  end

  test "push and popr from queue" do
    q = push_1_4
    assert Queue.popr(q) == { 1, %Queue{front: [4, 3], rear: [2]} }
  end

  test "pushr and popr from queue" do
    q = pushr_1_4
    assert Queue.popr(q) == { 4, %Queue{front: [1], rear: [3, 2]} }
  end

  test "pop from empty queue" do
    q = Queue.new()
    assert Queue.pop(q) == :empty
  end

  test "peek queue" do
    q = push_1_4
    assert Queue.peek(q) == { :ok, 4 }
  end

  test "peekr queue" do
    q = push_1_4
    assert Queue.peekr(q) == { :ok, 1 }
  end

  test "peek empty queue" do
    q = Queue.new()
    assert Queue.peek(q) == :empty
  end

  test "push and drop from queue" do
    q = push_1_4
    assert Queue.drop(q) == %Queue{front: [3, 2], rear: [1]}
  end

  test "push and dropr from queue" do
    q = push_1_4
    assert Queue.dropr(q) == %Queue{front: [4, 3], rear: [2]}
  end

  test "Enumerable implementation" do
    q = push_1_4

    assert Enum.map(q, &(&1)) == [4, 3, 2, 1]
    assert Enum.member?(q, 3) == true
    assert Enum.member?(q, 0) == false
    assert Enum.count(q) == 4
    assert Enum.take_while(q, &(&1 > 2)) == [4, 3]
  end

  test "Collectable implementation" do
    q1 = push_1_4
    q2 = for n <- 1..4, into: Queue.new(), do: n

    q1 == q2
  end
end
