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
        
        base = self.root
        
        # If node is None return minimum
        if node is None:
            # Start at root
            node = self.root

            while node.left is not None:
                node = node.left
            # Return the key value of that node
            return node
        
        # Make initialization of node
        previous = None
        
        # We traverse tree starting from root and only update previous when we
        # traverse to its eft part
        while base is not None:

            if base.key > node.key:
                previous = base
                base = base.left
            else:
                base = base.right
        
        # If node is the biggest one from the whole tree return None
        if previous is node:
             return None 

        # Return the successor
        return previous


