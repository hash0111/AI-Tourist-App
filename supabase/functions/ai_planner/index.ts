import "@supabase/functions-js/edge-runtime.d.ts";

interface PlanRequest {
  query: string;
  budget: number;
}

const SYSTEM_PROMPT = `You are an AI travel planner specialized in Jharkhand, India tourism. Create detailed, practical travel plans based on the user's query and budget.

Jharkhand destinations to consider:
- Ranchi (capital, waterfalls: Hundru, Jonha, Dassam, parks, temples)
- Jamshedpur (Jubilee Park, Dimna Lake, Dalma Hills, Tata Steel)
- Deoghar (Baba Baidyanath Temple, Nandan Pahar, Satsang Ashram)
- Dumka (Massanjore Dam, Basukinath Temple, hill views)
- Netarhat (hill station, sunrise/sunset points, Koel View Point)
- Betla National Park (wildlife, tiger reserve, Palamau Fort)
- Hazaribagh (Hazaribagh National Park, Canary Hill, Rajrappa)
- Rajrappa (waterfall + Chhinnamasta Temple)
- Seraikela (traditional culture, Chhau dance)
- Parasnath (Jain pilgrimage hill)
- Itkhori (ancient Buddhist/Hindu site)

Local cuisine: Thekua, Dhuska, Litti Chokha, Pittha, Rugra (mushroom), Bamboo shoot curry, Chilka roti, Malpua, Handia (rice beer)

Traditional attire: Bhagwanpur silk, Tussar silk, woven sarees

Respond with STRICT JSON (no markdown, no code fences) with this exact structure:
{
  "destination": "string",
  "duration": "string (e.g. '3 days, 2 nights')",
  "summary": "string (2-3 sentence overview)",
  "bestTimeToVisit": "string",
  "itinerary": [
    {
      "day": number,
      "title": "string",
      "description": "string",
      "activities": ["string"],
      "meals": ["string"],
      "accommodation": "string",
      "estimatedCost": number
    }
  ],
  "budgetBreakdown": {
    "transport": number,
    "accommodation": number,
    "food": number,
    "activities": number,
    "miscellaneous": number
  },
  "totalEstimatedCost": number,
  "currency": "INR",
  "tips": ["string"]
}`;

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
    const { query, budget } = await req.json() as PlanRequest;

    if (!query || typeof query !== "string") {
      return new Response(
        JSON.stringify({ success: false, error: "Missing or invalid 'query' (string required)" }),
        { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } },
      );
    }
    if (typeof budget !== "number" || budget <= 0) {
      return new Response(
        JSON.stringify({ success: false, error: "Missing or invalid 'budget' (positive number required)" }),
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

    const userPrompt = `Create a Jharkhand travel plan with:
- Trip details: ${query}
- Total budget: ₹${budget}

All costs must be in INR. Ensure the totalEstimatedCost does not exceed ₹${budget}. Be realistic and practical.`;

    const response = await fetch("https://api.groq.com/openai/v1/chat/completions", {
      method: "POST",
      headers: {
        "Authorization": `Bearer ${apiKey}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        model: "llama-3.3-70b-versatile",
        messages: [
          { role: "system", content: SYSTEM_PROMPT },
          { role: "user", content: userPrompt },
        ],
        response_format: { type: "json_object" },
        temperature: 0.7,
      }),
    });

    if (!response.ok) {
      const errorBody = await response.text();
      throw new Error(`Groq API error (${response.status}): ${errorBody}`);
    }

    const data = await response.json();
    const planText = data.choices?.[0]?.message?.content;
    if (!planText) {
      throw new Error("No response from Groq");
    }

    const plan = JSON.parse(planText);

    return new Response(
      JSON.stringify({ success: true, plan }),
      { status: 200, headers: { ...corsHeaders, "Content-Type": "application/json" } },
    );
  } catch (error) {
    console.error("AI Planner error:", error);
    return new Response(
      JSON.stringify({
        success: false,
        error: error instanceof Error ? error.message : "Internal server error",
      }),
      { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } },
    );
  }
});
