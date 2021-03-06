#ifndef AMICI_MODEL_DAE_H
#define AMICI_MODEL_DAE_H

#include "amici/model.h"

#include <nvector/nvector_serial.h>

#include <sunmatrix/sunmatrix_band.h>
#include <sunmatrix/sunmatrix_dense.h>
#include <sunmatrix/sunmatrix_sparse.h>

#include <utility>
#include <vector>

namespace amici {
extern msgIdAndTxtFp warnMsgIdAndTxt;

class ExpData;
class IDASolver;

/**
 * @brief The Model class represents an AMICI DAE model.
 *
 * The model does not contain any data, but represents the state
 * of the model at a specific time t. The states must not always be
 * in sync, but may be updated asynchroneously.
 */
class Model_DAE : public Model {
  public:
    /** default constructor */
    Model_DAE() = default;

    /**
     * @brief Constructor with model dimensions
     * @param nx_rdata number of state variables
     * @param nxtrue_rdata number of state variables of the non-augmented model
     * @param nx_solver number of state variables with conservation laws applied
     * @param nxtrue_solver number of state variables of the non-augmented model
     with conservation laws applied
     * @param ny number of observables
     * @param nytrue number of observables of the non-augmented model
     * @param nz number of event observables
     * @param nztrue number of event observables of the non-augmented model
     * @param ne number of events
     * @param nJ number of objective functions
     * @param nw number of repeating elements
     * @param ndwdx number of nonzero elements in the x derivative of the
     * repeating elements
     * @param ndwdp number of nonzero elements in the p derivative of the
     * repeating elements
     * @param ndxdotdw number of nonzero elements dxdotdw
     * @param ndJydy number of nonzero elements dJydy
     * @param nnz number of nonzero elements in Jacobian
     * @param ubw upper matrix bandwidth in the Jacobian
     * @param lbw lower matrix bandwidth in the Jacobian
     * @param o2mode second order sensitivity mode
     * @param p parameters
     * @param k constants
     * @param plist indexes wrt to which sensitivities are to be computed
     * @param idlist indexes indicating algebraic components (DAE only)
     * @param z2event mapping of event outputs to events
     */
    Model_DAE(const int nx_rdata, const int nxtrue_rdata, const int nx_solver,
              const int nxtrue_solver, const int ny, const int nytrue,
              const int nz, const int nztrue, const int ne, const int nJ,
              const int nw, const int ndwdx, const int ndwdp,
              const int ndxdotdw, std::vector<int> ndJydy, const int nnz,
              const int ubw, const int lbw, const SecondOrderMode o2mode,
              std::vector<realtype> const &p, std::vector<realtype> const &k,
              std::vector<int> const &plist,
              std::vector<realtype> const &idlist,
              std::vector<int> const &z2event)
        : Model(nx_rdata, nxtrue_rdata, nx_solver, nxtrue_solver, ny, nytrue,
                nz, nztrue, ne, nJ, nw, ndwdx, ndwdp, ndxdotdw,
                std::move(ndJydy), nnz, ubw, lbw, o2mode, p, k, plist, idlist,
                z2event) {}

    void fJ(realtype t, realtype cj, const AmiVector &x, const AmiVector &dx,
            const AmiVector &xdot, SUNMatrix J) override;

    /**
     * @brief Jacobian of xdot with respect to states x
     * @param t timepoint
     * @param cj scaling factor, inverse of the step size
     * @param x Vector with the states
     * @param dx Vector with the derivative states
     * @param xdot Vector with the right hand side
     * @param J Matrix to which the Jacobian will be written
     **/
    void fJ(realtype t, realtype cj, N_Vector x, N_Vector dx, N_Vector xdot,
            SUNMatrix J);

    /**
     * @brief Jacobian of xBdot with respect to adjoint state xB
     * @param t timepoint
     * @param cj scaling factor, inverse of the step size
     * @param x Vector with the states
     * @param dx Vector with the derivative states
     * @param xB Vector with the adjoint states
     * @param dxB Vector with the adjoint derivative states
     * @param JB Matrix to which the Jacobian will be written
     **/

    void fJB(realtype t, realtype cj, N_Vector x, N_Vector dx, N_Vector xB,
             N_Vector dxB, SUNMatrix JB);

    void fJSparse(realtype t, realtype cj, const AmiVector &x,
                  const AmiVector &dx, const AmiVector &xdot,
                  SUNMatrix J) override;

    /**
     * @brief J in sparse form (for sparse solvers from the SuiteSparse Package)
     * @param t timepoint
     * @param cj scalar in Jacobian (inverse stepsize)
     * @param x Vector with the states
     * @param dx Vector with the derivative states
     * @param J Matrix to which the Jacobian will be written
     */
    void fJSparse(realtype t, realtype cj, N_Vector x, N_Vector dx,
                  SUNMatrix J);

    /** JB in sparse form (for sparse solvers from the SuiteSparse Package)
     * @param t timepoint
     * @param cj scalar in Jacobian
     * @param x Vector with the states
     * @param dx Vector with the derivative states
     * @param xB Vector with the adjoint states
     * @param dxB Vector with the adjoint derivative states
     * @param JB Matrix to which the Jacobian will be written
     */
    void fJSparseB(realtype t, realtype cj, N_Vector x, N_Vector dx,
                   N_Vector xB, N_Vector dxB, SUNMatrix JB);

    /** diagonalized Jacobian (for preconditioning)
     * @param t timepoint
     * @param JDiag Vector to which the Jacobian diagonal will be written
     * @param cj scaling factor, inverse of the step size
     * @param x Vector with the states
     * @param dx Vector with the derivative states
     **/

    void fJDiag(realtype t, AmiVector &JDiag, realtype cj, const AmiVector &x,
                const AmiVector &dx) override;

    void fJv(realtype t, const AmiVector &x, const AmiVector &dx,
             const AmiVector &xdot, const AmiVector &v, AmiVector &nJv,
             realtype cj) override;

    /** Matrix vector product of J with a vector v (for iterative solvers)
     * @param t timepoint @type realtype
     * @param cj scaling factor, inverse of the step size
     * @param x Vector with the states
     * @param dx Vector with the derivative states
     * @param v Vector with which the Jacobian is multiplied
     * @param Jv Vector to which the Jacobian vector product will be
     * written
     **/
    void fJv(realtype t, N_Vector x, N_Vector dx, N_Vector v, N_Vector Jv,
             realtype cj);

    /** Matrix vector product of JB with a vector v (for iterative solvers)
     * @param t timepoint
     * @param x Vector with the states
     * @param dx Vector with the derivative states
     * @param xB Vector with the adjoint states
     * @param dxB Vector with the adjoint derivative states
     * @param vB Vector with which the Jacobian is multiplied
     * @param JvB Vector to which the Jacobian vector product will be
     *written
     * @param cj scalar in Jacobian (inverse stepsize)
     **/

    void fJvB(realtype t, N_Vector x, N_Vector dx, N_Vector xB, N_Vector dxB,
              N_Vector vB, N_Vector JvB, realtype cj);

    void froot(realtype t, const AmiVector &x, const AmiVector &dx,
               gsl::span<realtype> root) override;

    /** Event trigger function for events
     * @param t timepoint
     * @param x Vector with the states
     * @param dx Vector with the derivative states
     * @param root array with root function values
     */
    void froot(realtype t, N_Vector x, N_Vector dx, gsl::span<realtype> root);

    void fxdot(realtype t, const AmiVector &x, const AmiVector &dx,
               AmiVector &xdot) override;

    /**
     * @brief Residual function of the DAE
     * @param t timepoint
     * @param x Vector with the states
     * @param dx Vector with the derivative states
     * @param xdot Vector with the right hand side
     */
    void fxdot(realtype t, N_Vector x, N_Vector dx, N_Vector xdot);

    /** Right hand side of differential equation for adjoint state xB
     * @param t timepoint
     * @param x Vector with the states
     * @param dx Vector with the derivative states
     * @param xB Vector with the adjoint states
     * @param dxB Vector with the adjoint derivative states
     * @param xBdot Vector with the adjoint right hand side
     */
    void fxBdot(realtype t, N_Vector x, N_Vector dx, N_Vector xB, N_Vector dxB,
                N_Vector xBdot);

    /** Right hand side of integral equation for quadrature states qB
     * @param t timepoint
     * @param x Vector with the states
     * @param dx Vector with the derivative states
     * @param xB Vector with the adjoint states
     * @param dxB Vector with the adjoint derivative states
     * @param qBdot Vector with the adjoint quadrature right hand side
     */
    void fqBdot(realtype t, N_Vector x, N_Vector dx, N_Vector xB, N_Vector dxB,
                N_Vector qBdot);

    /** Sensitivity of dx/dt wrt model parameters p
     * @param t timepoint
     * @param x Vector with the states
     * @param dx Vector with the derivative states
     */
    void fdxdotdp(realtype t, const N_Vector x, const N_Vector dx);
    void fdxdotdp(const realtype t, const AmiVector &x,
                  const AmiVector &dx) override {
        fdxdotdp(t, x.getNVector(), dx.getNVector());
    };

    void fsxdot(realtype t, const AmiVector &x, const AmiVector &dx, int ip,
                const AmiVector &sx, const AmiVector &sdx,
                AmiVector &sxdot) override;
    /** Right hand side of differential equation for state sensitivities sx
     * @param t timepoint
     * @param x Vector with the states
     * @param dx Vector with the derivative states
     * @param ip parameter index
     * @param sx Vector with the state sensitivities
     * @param sdx Vector with the derivative state sensitivities
     * @param sxdot Vector with the sensitivity right hand side
     */
    void fsxdot(realtype t, N_Vector x, N_Vector dx, int ip, N_Vector sx,
                N_Vector sdx, N_Vector sxdot);

    /**
     * @brief Mass matrix for DAE systems
     * @param t timepoint
     * @param x Vector with the states
     */
    void fM(realtype t, const N_Vector x);

    std::unique_ptr<Solver> getSolver() override;

  protected:
    /**
     * @brief Model specific implementation for fJ
     * @param J Matrix to which the Jacobian will be written
     * @param t timepoint
     * @param x Vector with the states
     * @param p parameter vector
     * @param k constants vector
     * @param h heavyside vector
     * @param cj scaling factor, inverse of the step size
     * @param dx Vector with the derivative states
     * @param w vector with helper variables
     * @param dwdx derivative of w wrt x
     **/
    virtual void fJ(realtype *J, realtype t, const realtype *x, const double *p,
                    const double *k, const realtype *h, realtype cj,
                    const realtype *dx, const realtype *w,
                    const realtype *dwdx) = 0;

    /**
     * @brief model specific implementation for fJB
     * @param JB Matrix to which the Jacobian will be written
     * @param t timepoint
     * @param x Vector with the states
     * @param p parameter vector
     * @param k constants vector
     * @param h heavyside vector
     * @param cj scaling factor, inverse of the step size
     * @param xB Vector with the adjoint states
     * @param dx Vector with the derivative states
     * @param dxB Vector with the adjoint derivative states
     * @param w vector with helper variables
     * @param dwdx derivative of w wrt x
     **/
    virtual void fJB(realtype *JB, realtype t, const realtype *x,
                     const double *p, const double *k, const realtype *h,
                     realtype cj, const realtype *xB, const realtype *dx,
                     const realtype *dxB, const realtype *w,
                     const realtype *dwdx);

    /**
     * @brief model specific implementation for fJSparse
     * @param JSparse Matrix to which the Jacobian will be written
     * @param t timepoint
     * @param x Vector with the states
     * @param p parameter vector
     * @param k constants vector
     * @param h heavyside vector
     * @param cj scaling factor, inverse of the step size
     * @param dx Vector with the derivative states
     * @param w vector with helper variables
     * @param dwdx derivative of w wrt x
     **/
    virtual void fJSparse(SUNMatrixContent_Sparse JSparse, realtype t,
                          const realtype *x, const double *p, const double *k,
                          const realtype *h, realtype cj, const realtype *dx,
                          const realtype *w, const realtype *dwdx) = 0;

    /**
     * @brief Model specific implementation for fJSparseB
     * @param JSparseB Matrix to which the Jacobian will be written
     * @param t timepoint
     * @param x Vector with the states
     * @param p parameter vector
     * @param k constants vector
     * @param h heavyside vector
     * @param cj scaling factor, inverse of the step size
     * @param xB Vector with the adjoint states
     * @param dx Vector with the derivative states
     * @param dxB Vector with the adjoint derivative states
     * @param w vector with helper variables
     * @param dwdx derivative of w wrt x
     **/
    virtual void fJSparseB(SUNMatrixContent_Sparse JSparseB, const realtype t,
                           const realtype *x, const double *p, const double *k,
                           const realtype *h, const realtype cj,
                           const realtype *xB, const realtype *dx,
                           const realtype *dxB, const realtype *w,
                           const realtype *dwdx);

    /**
     * @brief Model specific implementation for fJDiag
     * @param JDiag array to which the Jacobian diagonal will be written
     * @param t timepoint
     * @param x Vector with the states
     * @param p parameter vector
     * @param k constants vector
     * @param h heavyside vector
     * @param cj scaling factor, inverse of the step size
     * @param dx Vector with the derivative states
     * @param w vector with helper variables
     * @param dwdx derivative of w wrt x
     **/
    virtual void fJDiag(realtype *JDiag, realtype t, const realtype *x,
                        const realtype *p, const realtype *k, const realtype *h,
                        realtype cj, const realtype *dx, const realtype *w,
                        const realtype *dwdx);

    /**
     * Model specific implementation for fJvB
     * @param JvB Matrix vector product of JB with a vector v
     * @param t timepoint
     * @param x Vector with the states
     * @param p parameter vector
     * @param k constants vector
     * @param h heavyside vector
     * @param cj scaling factor, inverse of the step size
     * @param xB Vector with the adjoint states
     * @param dx Vector with the derivative states
     * @param dxB Vector with the adjoint derivative states
     * @param vB Vector with which the Jacobian is multiplied
     * @param w vector with helper variables
     * @param dwdx derivative of w wrt x
     **/
    virtual void fJvB(realtype *JvB, realtype t, const realtype *x,
                      const double *p, const double *k, const realtype *h,
                      realtype cj, const realtype *xB, const realtype *dx,
                      const realtype *dxB, const realtype *vB,
                      const realtype *w, const realtype *dwdx);

    /**
     * @brief Model specific implementation for froot
     * @param root values of the trigger function
     * @param t timepoint
     * @param x Vector with the states
     * @param p parameter vector
     * @param k constants vector
     * @param h heavyside vector
     * @param dx Vector with the derivative states
     **/
    virtual void froot(realtype *root, realtype t, const realtype *x,
                       const double *p, const double *k, const realtype *h,
                       const realtype *dx);

    /**
     * @brief Model specific implementation for fxdot
     * @param xdot residual function
     * @param t timepoint
     * @param x Vector with the states
     * @param p parameter vector
     * @param k constants vector
     * @param h heavyside vector
     * @param w vector with helper variables
     * @param dx Vector with the derivative states
     **/
    virtual void fxdot(realtype *xdot, realtype t, const realtype *x,
                       const double *p, const double *k, const realtype *h,
                       const realtype *dx, const realtype *w) = 0;

    /**
     * @brief model specific implementation of fdxdotdp
     * @param dxdotdp partial derivative xdot wrt p
     * @param t timepoint
     * @param x Vector with the states
     * @param p parameter vector
     * @param k constants vector
     * @param h heavyside vector
     * @param ip parameter index
     * @param dx Vector with the derivative states
     * @param w vector with helper variables
     * @param dwdp derivative of w wrt p
     */
    virtual void fdxdotdp(realtype *dxdotdp, realtype t, const realtype *x,
                          const realtype *p, const realtype *k,
                          const realtype *h, int ip, const realtype *dx,
                          const realtype *w, const realtype *dwdp);

    /**
     * @brief model specific implementation of fM
     * @param M mass matrix
     * @param t timepoint
     * @param x Vector with the states
     * @param p parameter vector
     * @param k constants vector
     */
    virtual void fM(realtype *M, const realtype t, const realtype *x,
                    const realtype *p, const realtype *k){};
};
} // namespace amici

#endif // MODEL_H
