import "@supabase/functions-js/edge-runtime.d.ts";

interface TranslateRequest {
  text: string;
  sourceLanguage: string;
  targetLanguage: string;
}

const LANGUAGE_MAP: Record<string, string> = {
  "Santhali": "Santali",
  "Kurukh": "Kurukh",
  "Mundari": "Mundari",
  "Khortha": "Khortha",
  "Nagpuri": "Nagpuri",
  "Ho": "Ho",
  "Kharia": "Kharia",
  "English": "English",
  "Hindi": "Hindi",
};

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
  "Access-Control-Allow-Headers": "Content-Type, Authorization",
};

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response(null, { status: 204, headers: corsHeaders });
  }

  if (req.method !== "POST") {
    return new Response(
      JSON.stringify({ success: false, error: "Method not allowed" }),
      { status: 405, headers: { ...corsHeaders, "Content-Type": "application/json" } },
    );
  }

  try {
    const { text, sourceLanguage, targetLanguage } = await req.json() as TranslateRequest;

    if (!text || typeof text !== "string") {
      return new Response(
        JSON.stringify({ success: false, error: "Missing 'text'" }),
        { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } },
      );
    }

    const apiKey = Deno.env.get("GROQ_API_KEY");
    if (!apiKey) {
      return new Response(
        JSON.stringify({ success: false, error: "GROQ_API_KEY not configured" }),
        { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } },
      );
    }

    const systemPrompt = `You are a translator specializing in Jharkhand's regional languages: Santali, Kurukh, Mundari, Khortha, Nagpuri, Ho, and Kharia.
Translate the given text from ${sourceLanguage} to ${targetLanguage}.
Respond with STRICT JSON (no markdown): { "translatedText": "string", "transliteration": "string (pronunciation guide in English)", "usageNote": "string (optional context about when to use this)" }`;

    const userPrompt = `Translate from ${sourceLanguage} to ${targetLanguage}: "${text}"`;

    const response = await fetch("https://api.groq.com/openai/v1/chat/completions", {
      method: "POST",
      headers: {
        "Authorization": `Bearer ${apiKey}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        model: "llama-3.3-70b-versatile",
        messages: [
          { role: "system", content: systemPrompt },
          { role: "user", content: userPrompt },
        ],
        response_format: { type: "json_object" },
        temperature: 0.3,
      }),
    });

    if (!response.ok) {
      const errorBody = await response.text();
      throw new Error(`Groq API error (${response.status}): ${errorBody}`);
    }

    const data = await response.json();
    const resultText = data.choices?.[0]?.message?.content;
    if (!resultText) throw new Error("No response from Groq");

    const translated = JSON.parse(resultText);

    return new Response(
      JSON.stringify({ success: true, ...translated }),
      { status: 200, headers: { ...corsHeaders, "Content-Type": "application/json" } },
    );
  } catch (error) {
    console.error("Translate error:", error);
    return new Response(
      JSON.stringify({
        success: false,
        error: error instanceof Error ? error.message : "Internal server error",
      }),
      { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } },
    );
  }
});
