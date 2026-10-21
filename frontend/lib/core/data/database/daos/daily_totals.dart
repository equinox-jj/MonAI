/// One day's income minus expenses, in rupiah; transfers count as zero.
typedef DailyNet = ({DateTime date, int net});

/// One day's total of some transactions, in positive rupiah.
typedef DailyAmount = ({DateTime date, int amount});
