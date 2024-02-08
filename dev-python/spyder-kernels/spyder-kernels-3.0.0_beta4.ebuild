# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( pypy3 python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Kernels used by spyder on its ipython console"
HOMEPAGE="
	https://github.com/spyder-ide/spyder-kernels/
	https://pypi.org/project/spyder-kernels/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""

RDEPEND="
	dev-python/cloudpickle[${PYTHON_USEDEP}]
	<dev-python/ipykernel-7[${PYTHON_USEDEP}]
	>=dev-python/ipykernel-6.23.2[${PYTHON_USEDEP}]
	<dev-python/ipython-9[${PYTHON_USEDEP}]
	>dev-python/ipython-8.13.0[${PYTHON_USEDEP}]
	<dev-python/jupyter-client-9[${PYTHON_USEDEP}]
	>=dev-python/jupyter-client-7.4.9[${PYTHON_USEDEP}]
	dev-python/matplotlib-inline[${PYTHON_USEDEP}]
	>=dev-python/pyxdg-0.26[${PYTHON_USEDEP}]
	>=dev-python/pyzmq-22.1.0[${PYTHON_USEDEP}]
	>=dev-python/wurlitzer-1.0.3[${PYTHON_USEDEP}]
"

BDEPEND="
	test? (
		dev-python/cython[${PYTHON_USEDEP}]
		dev-python/django[${PYTHON_USEDEP}]
		dev-python/flaky[${PYTHON_USEDEP}]
		dev-python/matplotlib[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/scipy[${PYTHON_USEDEP}]
		dev-python/pillow[${PYTHON_USEDEP}]
		$(python_gen_cond_dep '
			dev-python/h5py[${PYTHON_USEDEP}]
			dev-python/pandas[${PYTHON_USEDEP}]
			dev-python/xarray[${PYTHON_USEDEP}]
		' 'python*')
	)
"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# we no longer package distributed, and also removed dependency on dask
	spyder_kernels/console/tests/test_console_kernel.py::test_dask_multiprocessing

	# RuntimeError: There is no current event loop in thread 'MainThread'.
	# https://bugs.gentoo.org/834893
	spyder_kernels/console/tests/test_console_kernel.py::test_cwd_in_sys_path
	spyder_kernels/console/tests/test_console_kernel.py::test_multiprocessing
	spyder_kernels/console/tests/test_console_kernel.py::test_multiprocessing_2
	spyder_kernels/console/tests/test_console_kernel.py::test_runfile
	spyder_kernels/console/tests/test_console_kernel.py::test_np_threshold
	spyder_kernels/console/tests/test_console_kernel.py::test_turtle_launch
	spyder_kernels/console/tests/test_console_kernel.py::test_matplotlib_inline

	# pydicom only packaged in ::sci at the moment
	spyder_kernels/utils/tests/test_iofuncs.py::test_load_dicom_files
)

python_test() {
	if [[ ${EPYTHON} == pypy3 ]]; then
		EPYTEST_IGNORE=(
			# requires pandas
			spyder_kernels/utils/tests/test_nsview.py
		)
		EPYTEST_DESELECT+=(
			# requires hdf5
			spyder_kernels/utils/tests/test_iofuncs.py::test_save_load_hdf5_files
			spyder_kernels/utils/tests/test_dochelpers.py
		)
	fi
	distutils-r1_python_test
}
