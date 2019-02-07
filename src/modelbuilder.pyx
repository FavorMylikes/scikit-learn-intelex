cdef extern from "modelbuilder.h":
    ctypedef size_t c_NodeId
    ctypedef size_t c_TreeId
    cdef size_t c_noParent

    cdef cppclass c_decision_forest_classification_ModelBuilder:
        c_decision_forest_classification_ModelBuilder(size_t nClasses, size_t nTrees) except +
        c_TreeId createTree(size_t nNodes)
        c_NodeId addLeafNode(c_TreeId treeId, c_NodeId parentId, size_t position, size_t classLabel)
        c_NodeId addSplitNode(c_TreeId treeId, c_NodeId parentId, size_t position, size_t featureIndex, double featureValue)

    cdef decision_forest_classification_ModelPtr * get_decision_forest_classification_modelbuilder_Model(c_decision_forest_classification_ModelBuilder *);


cdef class decision_forest_classification_modelbuilder:

    cdef c_decision_forest_classification_ModelBuilder * c_ptr

    def __cinit__(self, size_t nClasses, size_t nTrees):
        self.c_ptr = new c_decision_forest_classification_ModelBuilder(nClasses, nTrees)

    def __dealloc__(self):
        del self.c_ptr

    def create_tree(self, size_t nNodes):
        return self.c_ptr.createTree(nNodes)

    def add_leaf(self, c_TreeId treeId, size_t classLabel, c_NodeId parentId=c_noParent, size_t position=0):
        return self.c_ptr.addLeafNode(treeId, parentId, position, classLabel)

    def add_split(self, c_TreeId treeId, size_t featureIndex, double featureValue, c_NodeId parentId=c_noParent, size_t position=0):
        return self.c_ptr.addSplitNode(treeId, parentId, position, featureIndex, featureValue)

    def model(self):
        cdef decision_forest_classification_model res = decision_forest_classification_model.__new__(decision_forest_classification_model)
        res.c_ptr = get_decision_forest_classification_modelbuilder_Model(self.c_ptr)
        return res


def model_builder(nTrees=1, nClasses=2):
    '''
    Currently we support only decision forest classification models.
    The future may bring us more.
    '''
    return decision_forest_classification_modelbuilder(nClasses, nTrees)
