defmodule QueueTest do
  use ExUnit.Case

  defp put_1_4 do
    Queue.new()
    |> Queue.put(1)
    |> Queue.put(2)
    |> Queue.put(3)
    |> Queue.put(4)
  end

  defp put_rear_1_4 do
    Queue.new()
    |> Queue.put_rear(1)
    |> Queue.put_rear(2)
    |> Queue.put_rear(3)
    |> Queue.put_rear(4)
  end

  test "new queue" do
    assert Queue.new() == %Queue{front: [], rear: []}
  end

  test "put item" do
    q = Queue.new()
    assert Queue.put(q, 1) == %Queue{front: [1], rear: []}
  end

  test "put_rear item" do
    q = Queue.new()
    assert Queue.put_rear(q, 1) == %Queue{front: [], rear: [1]}
  end

  test "put and pop from queue" do
    q = put_1_4
    assert Queue.pop(q) == { 1, %Queue{front: [4, 3], rear: [2]} }
  end

  test "put and pop_front from queue" do
    q = put_1_4
    assert Queue.pop_front(q) == { 4, %Queue{front: [3, 2], rear: [1]} }
  end

  test "put_rear and pop_front from queue" do
    q = put_rear_1_4
    assert Queue.pop_front(q) == { 1, %Queue{front: [2], rear: [4, 3]} }
  end

  test "pop from empty queue" do
    q = Queue.new()
    assert Queue.pop(q) == :empty
  end

  test "peek queue" do
    q = put_1_4
    assert Queue.peek(q) == { :ok, 1 }
  end

  test "peek_front queue" do
    q = put_1_4
    assert Queue.peek_front(q) == { :ok, 4 }
  end

  test "peek empty queue" do
    q = Queue.new()
    assert Queue.peek(q) == :empty
  end

  test "drop from queue" do
    q = put_1_4
    assert Queue.drop(q) == %Queue{front: [4, 3], rear: [2]}
  end

  test "drop_front from queue" do
    q = put_1_4
    assert Queue.drop_front(q) == %Queue{front: [3, 2], rear: [1]}
  end

  test "join" do
    q1 = put_1_4
    q2 = put_rear_1_4

    assert Queue.join(q1, q2) == %Queue{front: [4, 3, 2, 1, 1], rear: [4, 3, 2]}
  end

  test "to_list" do
    q = put_1_4

    assert Queue.to_list(q) == [1, 2, 3, 4]
  end

  test "Enumerable implementation" do
    q = put_1_4

    assert Enum.map(q, &(&1)) == [1, 2, 3, 4]
    assert Enum.member?(q, 3) == true
    assert Enum.member?(q, 0) == false
    assert Enum.count(q) == 4
    assert Enum.take_while(q, &(&1 < 3)) == [1, 2]
  end

  test "Collectable implementation" do
    q1 = put_1_4
    q2 = for n <- 1..4, into: Queue.new(), do: n

    assert q1 == q2
  end
end
