---
title: "双端链表"
date: 2019-12-16T14:45:50+08:00
tags: [".NET","csharp","数据结构"]
categories: ["技术"]
draft: false
---
双端链表<!--more-->

## 定义
双端链表和单链表类似，只不过需要多维护一个指向最后一个节点的指针 Tail，方便从最后插入数据

## C# 实现
```csharp
void Main()
{
    DoubleEndedList list = new DoubleEndedList();
    list.InsertHead(2);
    list.InsertHead(1);
    list.InsertTail(3);
    list.InsertTail(4);
    list.DisplayList();

    Console.WriteLine("======Delete tail======");

    list.DeleteTail();
    list.DisplayList();

    list.DeleteTail();
    list.DisplayList();

    list.DeleteTail();
    list.DisplayList();

    list.DeleteTail();
    list.DisplayList();

    list.DeleteTail();
    list.DisplayList();

    list.InsertHead(2);
    list.InsertHead(1);
    list.InsertTail(3);
    list.InsertTail(4);
    list.DisplayList();

    Console.WriteLine("======Delete head======");

    list.DeleteHead();
    list.DisplayList();

    list.DeleteHead();
    list.DisplayList();

    list.DeleteHead();
    list.DisplayList();

    list.DeleteHead();
    list.DisplayList();

    list.DeleteHead();
    list.DisplayList();
}

public class DoubleEndedList
{
    public Node? Head { get; set; }

    public Node? Tail { get; set; }

    public DoubleEndedList()
    {
        Head = null;
        Tail = null;
    }

    public bool IsEmpty()
    {
        return Head == null;
    }

    // 表头插入
    public void InsertHead(int dd)
    {
        Node newNode = new Node(dd);
        if (IsEmpty())
        {
            Tail = newNode;
        }

        newNode.Next = Head;
        Head = newNode;
    }

    // 表尾插入
    public void InsertTail(int dd)
    {
        Node newNode = new Node(dd);
        if (IsEmpty())
        {
            Head = newNode;
        }
        else
        {
            Tail.Next = newNode;
        }

        Tail = newNode;
    }

    // 删除表头
    public void DeleteHead()
    {
        if (Head == null)
        {
            return;
        }

        Console.WriteLine($"Delete {Head.Value}");
        Head = Head.Next;
        if (Head == null)
        {
            Tail = null;
        }
    }

    // 删除表尾
    public void DeleteTail()
    {
        if (Tail == null)
        {
            return;
        }

        if (Head == Tail)
        {
            Console.WriteLine($"Delete {Tail.Value}");
            Head = null;
            Tail = null;
        }
        else
        {
            Node? before = null;
            Node? current = Head;
            while (current != Tail)
            {
                before = current;
                current = current.Next;
            }

            Tail = before;
            Tail.Next = null;
            Console.WriteLine($"Delete {current.Value}");
        }
    }

    public void DisplayList()
    {
        Node? current = Head;
        if (current == null)
        {
            Console.WriteLine("(Empty)");
            return;
        }

        while (current != null)
        {
            current.DisplayNode();
            current = current.Next;
        }
    }
}

public class Node
{
    public Node? Next { get; set; }

    public int Value { get; set; }

    public Node(int v)
    {
        Value = v;
    }

    internal void DisplayNode()
    {
        Console.Write(Value);
        if (Next != null)
        {
            Console.Write("->");
        }
        else
        {
            Console.Write(Environment.NewLine);
        }
    }
}
```