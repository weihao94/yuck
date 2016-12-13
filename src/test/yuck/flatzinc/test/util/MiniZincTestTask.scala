package yuck.flatzinc.test.util

import yuck.flatzinc.FlatZincSolverConfiguration

/**
 * @author Michael Marte
 *
 */
sealed abstract class MiniZincDirectoryLayout
// all model (mzn) files in one folder, models contain data
case object MiniZincExamplesLayout extends MiniZincDirectoryLayout {}
// several model (mzn) and data (dzn) file in one folder, data files may be organized into sub folders
case object StandardMiniZincBenchmarksLayout extends MiniZincDirectoryLayout {}
// several model (mzn) files in one folder, models contain data
case object NonStandardMiniZincBenchmarksLayout extends MiniZincDirectoryLayout {}

/**
 * @author Michael Marte
 *
 */
case class MiniZincTestTask(
    val directoryLayout: MiniZincDirectoryLayout,
    val suitePath: String = "",
    val suiteName: String = "",
    val problemName: String = "",
    val modelName: String = "",
    val instanceName: String = "",
    val solverConfiguration: FlatZincSolverConfiguration = new FlatZincSolverConfiguration,
    val maybeOptimum: Option[Int] = None, // replicated from FlatZincSolverConfiguration for convenience
    val maybeQualityTolerance: Option[Int] = None, // replicated from FlatZincSolverConfiguration for convenience
    val logLevel: yuck.util.logging.LogLevel = yuck.util.logging.InfoLogLevel)
{
    def effectiveInstanceName: String = if (instanceName.isEmpty) problemName else instanceName
}