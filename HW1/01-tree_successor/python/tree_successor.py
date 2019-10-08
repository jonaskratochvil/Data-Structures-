#!/usr/bin/env python3


class Node:
    """Node in a binary tree `Tree`"""

    def __init__(self, key, left=None, right=None, parent=None):
        self.key = key
        self.left = left
        self.right = right
        self.parent = parent


class Tree:
    """A simple binary search tree"""

    def __init__(self, root=None):
        self.root = root

    def insert(self, key):
        """Insert key into the tree.

        If the key is already present, do nothing.
        """
        if self.root is None:
            self.root = Node(key)
            return

        node = self.root
        while node.key != key:
            if key < node.key:
                if node.left is None:
                    node.left = Node(key, parent=node)
                node = node.left
            else:
                if node.right is None:
                    node.right = Node(key, parent=node)
                node = node.right

    def successor(self, node=None):
        # If requested node has no node to its right (no node is greater)
        # we return None
        if node.right is None:
            return None

        # If requested node is None we return minimum by traversing from
        # root leftwards until Null pointer is reached -> than we output
        # the last visited node which is the minimum
        if node is None:
            # Start at root
            node = self.root

            while node.left is not None:
                node = node.left

        # Return the key value of that node
            return node.key

        # Start at the next node right
        node = node.right

        # Travers to the left until null pointer is reached
        while node.left is not None:
            node = node.left

        # Return the key value of that node
        return node.key

        """Return successor of the given node.

        The successor of a node is the node with the next greater key.
        Return None if there is no such node.
        If the argument is None, return the node with the smallest key.
        """
        # TODO: Implement
        raise NotImplementedError
