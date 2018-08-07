#*******************************************************************************
# Copyright 2014-2018 Intel Corporation
# All Rights Reserved.
#
# This software is licensed under the Apache License, Version 2.0 (the
# "License"), the following terms apply:
#
# You may not use this file except in compliance with the License.  You may
# obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#
# See the License for the specific language governing permissions and
# limitations under the License.
#*******************************************************************************

# daal4py PCA example for shared memory systems

import daal4py as d4p
from numpy import loadtxt, allclose

if __name__ == "__main__":

    infile = "./data/batch/pca_normalized.csv"
    method = 'svdDense'

    # configure a PCA object
    algo = d4p.pca(method=method)
    
    # let's provide a file directly, not a table/array
    result1 = algo.compute(infile)

    # We can also load the data ourselfs and provide the numpy array
    data = loadtxt(infile, delimiter=',')
    result2 = algo.compute(data)

    # PCA result objects provide eigenvalues, eigenvectors, means and variances
    assert allclose(result1.eigenvalues, result2.eigenvalues)
    assert allclose(result1.eigenvectors, result2.eigenvectors)
    assert result1.means == None and result2.means == None or allclose(result1.means, result2.means)
    assert result1.variances == None and result2.variances == None or allclose(result1.variances, result2.variances)

    print('All looks good!')