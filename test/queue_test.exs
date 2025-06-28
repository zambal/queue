defmodule QueueTest do
  use ExUnit.Case

  defp put_1_4 do
    Queue.new()
    |> Queue.put(1)
    |> Queue.put(2)
    |> Queue.put(3)
    |> Queue.put(4)
  end

  defp put_front_1_4 do
    Queue.new()
    |> Queue.put_front(1)
    |> Queue.put_front(2)
    |> Queue.put_front(3)
    |> Queue.put_front(4)
  end

  test "new queue" do
    assert %Queue{front: [], rear: []} = Queue.new()
  end

  test "put item" do
    q = Queue.new()
    assert %Queue{front: [], rear: [1]} = Queue.put(q, 1)
  end

  test "put_front item" do
    q = Queue.new()
    assert %Queue{front: [1], rear: []} = Queue.put_front(q, 1)
  end

  test "put and pop from queue" do
    q = put_1_4()
    assert {1, %Queue{rear: [4, 3], front: [2]}} = Queue.pop(q)
  end

  test "put and pop_front from queue" do
    q = put_1_4()
    assert {4, %Queue{rear: [3, 2], front: [1]}} = Queue.pop_rear(q)
  end

  test "put_rear and pop_rear from queue" do
    q = put_front_1_4()
    assert {1, %Queue{rear: [2], front: [4, 3]}} = Queue.pop_rear(q)
  end

  test "pop from empty queue" do
    q = Queue.new()
    assert :empty = Queue.pop(q)
  end

  test "peek queue" do
    q = put_1_4()
    assert {:ok, 1} = Queue.peek(q)
  end

  test "peek_rear queue" do
    q = put_1_4()
    assert {:ok, 4} = Queue.peek_rear(q)
  end

  test "peek empty queue" do
    q = Queue.new()
    assert :empty = Queue.peek(q)
  end

  test "drop from queue" do
    q = put_1_4()
    assert %Queue{rear: [4, 3], front: [2]} = Queue.drop(q)
  end

  test "drop_rear from queue" do
    q = put_1_4()
    assert %Queue{rear: [3, 2], front: [1]} = Queue.drop_rear(q)
  end

  test "join" do
    q1 = put_1_4()
    q2 = put_front_1_4()

    assert %Queue{front: [1, 2, 3, 4, 4, 3, 2], rear: [1]} = Queue.join(q1, q2)
  end

  test "to_list" do
    q = put_1_4()

    assert [1, 2, 3, 4] = Queue.to_list(q)
  end

  test "from_list" do
    q1 = Enum.reduce(4..1//-1, Queue.new(), fn n, acc -> Queue.put_front(acc, n) end)
    q2 = Queue.from_list([1, 2, 3, 4])

    assert q1 == q2
  end

  test "to and from erl" do
    q = put_1_4()
    eq = :queue.new()
    eq = :queue.in(1, eq)
    eq = :queue.in(2, eq)
    eq = :queue.in(3, eq)
    eq = :queue.in(4, eq)

    assert ^eq = Queue.to_erl(q)
    assert ^q = Queue.from_erl(eq)

    q = put_front_1_4()
    eq = :queue.new()
    eq = :queue.in_r(1, eq)
    eq = :queue.in_r(2, eq)
    eq = :queue.in_r(3, eq)
    eq = :queue.in_r(4, eq)

    assert ^eq = Queue.to_erl(q)
    assert ^q = Queue.from_erl(eq)
  end

  test "Enumerable implementation" do
    q = put_1_4()

    assert [1, 2, 3, 4] = Enum.map(q, & &1)
    assert true = Enum.member?(q, 3)
    assert false === Enum.member?(q, 0)
    assert 4 = Enum.count(q)
    assert [1, 2] = Enum.take_while(q, &(&1 < 3))
    assert [3, 4] = Enum.slice(q, 2..3)
  end

  test "Collectable implementation" do
    q1 = put_1_4()
    q2 = for n <- 1..4, into: Queue.new(), do: n

    assert q1 == q2
  end
end
