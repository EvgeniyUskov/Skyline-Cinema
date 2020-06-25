import Foundation

public enum FeeCalculator {

    private static let minFee: Decimal = 0.01

    private static let defaultFeeBehavior = NSDecimalNumberHandler(roundingMode: .plain,
                                                                   scale: 2,
                                                                   raiseOnExactness: false,
                                                                   raiseOnOverflow: false,
                                                                   raiseOnUnderflow: false,
                                                                   raiseOnDivideByZero: false)

    /**
     * Метод расчета суммы к списанию со счета покупателя на основе суммы перечисления в магазин и комиссии:
     * amount = netAmount + min( max(a*netAmount + b, c), d)
     *
     *  - parameter netAmount: Cумма к перечислению в магазин (к получению)
     *  - parameter fee: Комиссия
     *
     *  - returns: Cумма к списанию со счета покупателя
     */
    public func amountFromNetAmount(_ netAmount: Decimal, fee: Fee) -> Decimal {

        guard netAmount != .nan else {
            return FeeCalculator.minFee
        }

        let netA = netAmount as NSDecimalNumber
        let feeA = fee.a as NSDecimalNumber
        let feeB = fee.b as NSDecimalNumber
        var localFee = feeA.multiplying(by: netA, withBehavior: FeeCalculator.defaultFeeBehavior) as Decimal
        localFee = (localFee as NSDecimalNumber).adding(feeB, withBehavior: FeeCalculator.defaultFeeBehavior) as Decimal
        localFee = localFee > fee.c ? localFee : fee.c

        if let d = fee.d, d != .nan {
            localFee = localFee > d ? d : localFee
        }

        localFee = localFee > FeeCalculator.minFee ? localFee : FeeCalculator.minFee
        let result = netA.adding(localFee as NSDecimalNumber, withBehavior: FeeCalculator.defaultFeeBehavior) as Decimal

        return result > FeeCalculator.minFee ? result : FeeCalculator.minFee
    }

    /**
     *  Метод расчета суммы перечисления в магазин на основе суммы к списанию со счета покупателя и комиссии:
     *
     *  - parameter amount: Cумма к списанию со счета покупателя
     *  - parameter fee: Комиссия
     *
     *  - returns: Cумма к перечислению в магазин (к получению)
     */
    public func netAmountFromAmount(_ amount: Decimal, fee: Fee) -> Decimal {
        var result: Decimal = 0

        guard amount != .nan else {
            return result
        }

        let amountD = amount as NSDecimalNumber
        let feeA = fee.a as NSDecimalNumber
        let feeB = fee.b as NSDecimalNumber
        let commonDenominator = (fee.a as NSDecimalNumber).adding(.one, withBehavior: FeeCalculator.defaultFeeBehavior)
        let numerator = amountD.multiplying(by: feeA, withBehavior: FeeCalculator.defaultFeeBehavior)
        let firstPart = numerator.dividing(by: commonDenominator, withBehavior: FeeCalculator.defaultFeeBehavior)
        let secondPart = feeB.dividing(by: commonDenominator, withBehavior: FeeCalculator.defaultFeeBehavior)
        var localFee = firstPart.adding(secondPart, withBehavior: FeeCalculator.defaultFeeBehavior) as Decimal

        localFee = localFee > fee.b ? localFee : fee.b
        localFee = localFee > fee.c ? localFee : fee.c

        if let d = fee.d, d != .nan {
            localFee = localFee > d ? d : localFee
        }

        let decimalFee = localFee as NSDecimalNumber
        let compNetAmount = amountD.subtracting(decimalFee, withBehavior: FeeCalculator.defaultFeeBehavior) as Decimal
        if compNetAmount > 1 {
            result = compNetAmount
        }

        return result
    }
}
