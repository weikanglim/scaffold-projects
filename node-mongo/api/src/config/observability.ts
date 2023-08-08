import winston from "winston";

export enum LogLevel {
    Error = "error",
    Warning = "warn",
    Information = "info",
    Verbose = "verbose",
    Debug = "debug",
}

export const logger = winston.createLogger({
    level: "info",
    format: winston.format.json(),
    transports: [
    //
    // - Write all logs with importance level of `error` or less to `error.log`
    // - Write all logs with importance level of `info` or less to `combined.log`
    //
        new winston.transports.File({ filename: "error.log", level: "error" }),
        new winston.transports.File({ filename: "combined.log" }),
    ],
    exceptionHandlers: [
        new winston.transports.File({ filename: "exceptions.log" }),
    ]
});

//
// If we're not in production then log to the `console` with the format:
// `${info.level}: ${info.message} JSON.stringify({ ...rest }) `
//
if (process.env.NODE_ENV !== "production") {
    logger.add(new winston.transports.Console({
        format: winston.format.simple(),
        handleExceptions: true,
    }));
}
