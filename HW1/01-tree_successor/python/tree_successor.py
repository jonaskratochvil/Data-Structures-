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
        """
         If requested node has no node to its right (no node is greater)
         If requested node is None we return minimum by traversing from
         root leftwards until Null pointer is reached -> than we output
         the last visited node which is the minimum
        """
        if node is None:
            # Start at root
            node = self.root

            while node.left is not None:
                node = node.left
            # Return the key value of that node
            return node

        # we have a single node in a tree we return that key
        elif (node.left is None) and (node.right is None) and (node.parent is None):
            return node

        # root is the node with highest key
        elif node.right is None and node is self.root:
            return None

        # Iam in left tree part and there is no right node from me
        elif node.right is None and node.key < node.parent.key:
            return node.parent

        elif node.right is None and node.parent.key < node.key:
            while node.parent.key < node.key:

                if node.parent is self.root:
                    return None

                node = node.parent

            return node.parent

        # Root is the smallest key
        elif node.left is None and node is self.root:
            return node.right

        elif node.left is None and node.parent.key > node.key:

            if node.right is not None:
                node = node.right

                while node.left is not None:
                    node = node.left
                return node
            else:
                return node.parent

        elif node.key < node.right.key:
            # Start at the next node right
            node = node.right

            # Travers to the left until null pointer is reached
            while node.left is not None:
                node = node.left

            # Return the key value of that node
            return node
