#!/usr/bin/env python3
import sys

import tree_successor


def test_sequence(sequence):
    tree = tree_successor.Tree()
    for i in sequence:
        tree.insert(i)

    # toto tedy zacne na minimum
    node = tree.successor(None)
    for element in sorted(sequence):
        print(node.key)
        assert node is not None, "Expected successor {}, got None".format(
            element)
        assert node.key == element, "Expected successor {}, got {}".format(
            element, node.key)
        node = tree.successor(node)
    assert node is None, "Expected no successor, got {}".format(node.key)


if __name__ == '__main__':
    sequence = [i for i in range(38)]
    test_sequence(sequence)
