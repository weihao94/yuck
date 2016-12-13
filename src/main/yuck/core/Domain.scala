package yuck.core

/**
 * Provides an interface for working with typed domains.
 *
 * @author Michael Marte
 */
abstract class Domain[Value <: AnyValue] extends AnyDomain {

    /** Provides the traits of the type of the domain's elements. */
    def valueTraits: AnyValueTraits[Value]

    @inline final override def valueType = valueTraits.valueType

    override def toString = "{%s}".format(values.map(_.toString).mkString(", "))

    override def values: TraversableOnce[Value]
    override def singleValue: Value

    /** Decides whether the domain contains the given value. */
    def contains(a: Value): Boolean

    /**
     * Returns a random value from the domain.
     *
     * Throws when the domain is empty or infinite.
     */
    def randomValue(randomGenerator: RandomGenerator): Value

    /**
     * Returns a random value from the domain that differs from the given value.
     *
     * Throws when the domain is infinite or has less than two elements.
     */
    def nextRandomValue(randomGenerator: RandomGenerator, currentValue: Value): Value

}