#!/usr/bin/env python3

class Node:
    """Node in a binary tree `Tree`"""

    def __init__(self, key, left=None, right=None, parent=None):
        self.key = key
        self.parent = parent
        self.left = left
        self.right = right
        if left is not None: left.parent = self
        if right is not None: right.parent = self

class Tree:
    """A simple binary search tree"""

    def __init__(self, root=None):
        self.root = root

    def rotate(self, node):
        """ Rotate the given `node` up.

        Performs a single rotation of the edge between the given node
        and its parent, choosing left or right rotation appropriately.
        """
        # This checks if the node is not in a root
        if node.parent is not None:
            
            # These two conditions deal with only two nodes
            if node.parent.left == node:
                # this tells me to associate right node to parent but does not tell me if left or right
                if node.right is not None: node.right.parent = node.parent
                # This tells me that it will be but to left
                node.parent.left = node.right
                # now parent of my node will be its right child
                node.right = node.parent
            else:
                # parent of my left child will now be my parent
                if node.left is not None: node.left.parent = node.parent
                # right child of my parent will now be my left one
                # everytime the thing aftret first dot represents to who we are adding and after second dot to which position
                # This again tells me to put the node to the left
                node.parent.right = node.left
                # now the node left of me will be my parent
                node.left = node.parent
            
            # Here we deal with the rest of the nodes
            if node.parent.parent is not None:
                if node.parent.parent.left == node.parent:
                    node.parent.parent.left = node
                else:
                    node.parent.parent.right = node
            else:
                # if the node is one below root it will become root
                self.root = node
            
            node.parent.parent, node.parent = node, node.parent.parent

    def lookup(self, key):
        """Look up the given key in the tree.
        Returns the node with the requested key or `None`.
        """
        node = self.root
        while node is not None:
            if node.key == key:
                self.splay(node)
                return self.root 
            if key < node.key:
                pred = node
                node = node.left
            else:
                pred = node
                node = node.right

        self.splay(pred)
        return None

    def insert(self, key):
            """Insert key into the tree.
            If the key is already present, do nothing.
            """
            # TODO: Utilize splay suitably.
            block = Tree

            if self.root is None:
                self.root = Node(key)
                return

            node = self.root
            while node.key != key:
                if key < node.key:
                    if node.left is None:
                        node.left = Node(key, parent=node)
                        self.splay(node)
                        block = False
                        break

                    node = node.left
                else:
                    if node.right is None:
                        node.right = Node(key, parent=node)
                        self.splay(node)
                        block = False
                        break
                    node = node.right
            # This happens when node is already present in tree
            if block:
                self.splay(node)

    def remove(self, key):
        """Remove given key from the tree.

        It the key is not present, do nothing.
        """
        # TODO: Utilize splay suitably.
        # This locates the node that we want to delete
        node = self.lookup(key)
        if node is not None:
            if node.left is not None and node.right is not None:
                left_tree = node.left 
                replacement = node.right
                self.root = replacement
                replacement.parent = None

                while replacement.left is not None:
                    replacement = replacement.left
                self.splay(replacement)
                
                replacement.left = left_tree
                left_tree.parent = replacement

                self.root = replacement
                
            elif node.left is None:
                self.root = node.right
                node.right.parent = None

            elif node.right is None:
                self.root = node.left
                node.left.parent =  None

            else:
                self.root = None

        else:
            return

    def splay(self, node):
        """Splay the given node.

        If a single rotation needs to be performed, perform it as the last rotation
        (i.e., to move the splayed node to the root of the tree).
        """
        if node is None:
            return

        while node.parent is not None:
            father = node.parent
            # If we are below root
            if (self.root.left is node) or (self.root.right is node) :
                self.rotate(node)
                break

            else:
                grandfather = father.parent

                if (father.left is node and grandfather.left is father) or (father.right is node and grandfather.right is father):
                    # TODO right right or left left
                    #  /    \
                    # /      \
                    # first rotate grandfather to get and than father to get better asymptotic complexity
                    self.rotate(father)
                    self.rotate(node)

                elif father.left is node and grandfather.right is father:

                    self.rotate(father.left)
                    self.rotate(grandfather.right)
                    
                else:

                    self.rotate(father.right)
                    self.rotate(grandfather.left)

